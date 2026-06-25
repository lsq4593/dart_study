// Dart 第七十八课：整合 — 持久化 RESTful API（shelf + sembast）
// 将第74课的 JSON API 与第77课的 sembast 数据库结合
//
// 特点：
//   1. 数据持久化（重启不丢失）
//   2. 完整的 RESTful CRUD
//   3. 参数校验 + 错误处理
//   4. 日志中间件

import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:sembast/sembast_io.dart';

// ═══════════════════════════════════════════════════
//  数据模型
// ═══════════════════════════════════════════════════

class Note {
  final int id;
  final String title;
  final String content;
  final String createdAt;

  Note(this.id, this.title, this.content, this.createdAt);

  /// 数据库记录 → Note
  factory Note.fromRecord(int id, Map<String, dynamic> data) => Note(
        id,
        data['title'] ?? '',
        data['content'] ?? '',
        data['createdAt'] ?? DateTime.now().toIso8601String(),
      );

  /// Note → Map（存入 sembast）
  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'createdAt': createdAt,
      };

  /// Note → JSON（返回给客户端）
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt,
      };
}

// ═══════════════════════════════════════════════════
//  数据库访问层
// ═══════════════════════════════════════════════════

class NoteStore {
  late final Database _db;
  final StoreRef _store = StoreRef.main();

  Future<void> open() async {
    _db = await databaseFactoryIo.openDatabase('notes_api.db');
  }

  Future<void> close() async => _db.close();

  /// CREATE — 创建笔记
  Future<Note> create(Map<String, dynamic> data) async {
    final record = {
      'title': (data['title'] ?? '').toString(),
      'content': (data['content'] ?? '').toString(),
      'createdAt': DateTime.now().toIso8601String(),
    };
    final id = await _store.add(_db, record);
    return Note.fromRecord(id as int, record);
  }

  /// READ — 全部笔记
  Future<List<Note>> findAll() async {
    final records = await _store.find(_db);
    return records
        .map((r) => Note.fromRecord(r.key as int, r.value as Map<String, dynamic>))
        .toList();
  }

  /// READ — 单个笔记
  Future<Note?> findById(int id) async {
    final record = await _store.record(id).get(_db);
    if (record == null) return null;
    return Note.fromRecord(id, record as Map<String, dynamic>);
  }

  /// UPDATE — 更新笔记（只合并传入的字段）
  Future<Note?> update(int id, Map<String, dynamic> data) async {
    final existing = await _store.record(id).get(_db);
    if (existing == null) return null;
    // 只覆盖传入的字段，保留其他字段
    final merged = {
      ...existing as Map<String, dynamic>,
      if (data.containsKey('title')) 'title': data['title'].toString(),
      if (data.containsKey('content')) 'content': data['content'].toString(),
    };
    await _store.record(id).update(_db, merged);
    return Note.fromRecord(id, merged);
  }

  /// DELETE — 删除笔记
  Future<bool> delete(int id) async {
    final existing = await _store.record(id).get(_db);
    if (existing == null) return false;
    await _store.record(id).delete(_db);
    return true;
  }
}

// ═══════════════════════════════════════════════════
//  工具函数
// ═══════════════════════════════════════════════════

Response jsonResponse(int status, Object data) => Response(
      status,
      body: jsonEncode(data),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

Future<Map<String, dynamic>?> readJson(Request request) async {
  try {
    final raw = await request.read().toList();
    final bytes = raw.expand((x) => x).toList();
    if (bytes.isEmpty) return null;
    final body = utf8.decode(bytes);
    return jsonDecode(body) as Map<String, dynamic>;
  } on FormatException {
    return null; // 调用方返回 400
  }
}

// ═══════════════════════════════════════════════════
//  日志中间件
// ═══════════════════════════════════════════════════

Middleware logMiddleware(IOSink log) {
  return (innerHandler) => (request) async {
        final sw = Stopwatch()..start();
        final response = await innerHandler(request);
        log.writeln(
            '[${DateTime.now()}] ${request.method} ${request.url.path} -> ${response.statusCode} (${sw.elapsedMilliseconds}ms)');
        await log.flush();
        return response;
      };
}

// ═══════════════════════════════════════════════════
//  主程序
// ═══════════════════════════════════════════════════

void main() async {
  final logFile = File('server78.log').openWrite(mode: FileMode.append);

  // 1. 打开数据库
  final store = NoteStore();
  await store.open();
  logFile.writeln('[${DateTime.now()}] 数据库已打开');

  // 2. 定义路由
  final router = Router()
    ..get('/notes', (request) async {
      final notes = await store.findAll();
      return jsonResponse(200, notes.map((n) => n.toJson()).toList());
    })
    ..get('/notes/<id>', (request, String idStr) async {
      final id = int.tryParse(idStr);
      if (id == null) {
        return jsonResponse(400, {'error': 'ID 必须是数字'});
      }
      final note = await store.findById(id);
      if (note == null) {
        return jsonResponse(404, {'error': '笔记不存在'});
      }
      return jsonResponse(200, note.toJson());
    })
    ..post('/notes', (request) async {
      final body = await readJson(request);
      if (body == null) {
        return jsonResponse(400, {'error': '请求体格式错误，请使用 UTF-8 编码的 JSON'});
      }
      final title = (body['title'] ?? '').toString().trim();
      if (title.isEmpty) {
        return jsonResponse(400, {'error': 'title 不能为空'});
      }
      final note = await store.create(body);
      return jsonResponse(201, note.toJson());
    })
    ..put('/notes/<id>', (request, String idStr) async {
      final id = int.tryParse(idStr);
      if (id == null) {
        return jsonResponse(400, {'error': 'ID 必须是数字'});
      }
      final body = await readJson(request);
      if (body == null) {
        return jsonResponse(400, {'error': '请求体格式错误，请使用 UTF-8 编码的 JSON'});
      }
      final note = await store.update(id, body);
      if (note == null) {
        return jsonResponse(404, {'error': '笔记不存在'});
      }
      return jsonResponse(200, note.toJson());
    })
    ..delete('/notes/<id>', (request, String idStr) async {
      final id = int.tryParse(idStr);
      if (id == null) {
        return jsonResponse(400, {'error': 'ID 必须是数字'});
      }
      final deleted = await store.delete(id);
      if (!deleted) {
        return jsonResponse(404, {'error': '笔记不存在'});
      }
      return jsonResponse(200, {'message': '已删除', 'id': id});
    });

  // 3. Pipeline：日志 → 路由
  final handler = Pipeline().addMiddleware(logMiddleware(logFile)).addHandler(router.call);

  // 4. 启动服务
  final server = await serve(handler, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 持久化 API 启动: http://localhost:${server.port}');
  await logFile.flush();

  print('服务器已启动: http://localhost:${server.port}');
  print('');
  print('可用接口:');
  print('  GET    /notes         获取全部笔记');
  print('  GET    /notes/<id>    获取单个笔记');
  print('  POST   /notes         创建笔记 (JSON: title, content)');
  print('  PUT    /notes/<id>    更新笔记 (JSON: title, content)');
  print('  DELETE /notes/<id>    删除笔记');
  print('');
  print('测试命令 (另开终端):');
  print(r'  curl http://localhost:8080/notes');
  print(r'  curl -X POST -H "Content-Type: application/json" -d "{\"title\":\"Hello\",\"content\":\"World\"}" http://localhost:8080/notes');
  print('');
  print('⚠  Windows 用户发送中文时，请确保终端使用 UTF-8 编码：');
  print('  方法1: 在 PowerShell 中用以下命令：');
  print(r'    Invoke-WebRequest -Uri http://localhost:8080/notes -Method POST');
  print(r'      -Headers @{"Content-Type"="application/json"}');
  print(r'      -Body ''{\"title\":\"学习Dart\",\"content\":\"第78课\"}''');
  print('  方法2: 将 JSON 保存为 UTF-8 文件后用 curl：');
  print(r'    curl -X POST -H "Content-Type: application/json" --data-binary @body.json http://localhost:8080/notes');
}
