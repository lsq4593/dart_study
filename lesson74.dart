// Dart 第七十四课：JSON API 开发
// 构建一个备忘录 RESTful API，全程 JSON 请求/响应

import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Note {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  Note(this.id, this.title, this.content, this.createdAt);
  Map<String, dynamic> toJson() => {
    'id': id, 'title': title,
    'content': content, 'createdAt': createdAt,
  };
}

Response jsonResponse(int status, Object data) => Response(
  status,
  body: jsonEncode(data),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Future<Map<String, dynamic>> readJson(Request request) async =>
  jsonDecode(await request.readAsString()) as Map<String, dynamic>;

void main() async {
  final logFile = File('server74.log').openWrite(mode: FileMode.append);
  var nextId = 1;
  final notes = <Note>[];

  final router = Router()
    ..get('/notes', (request) {
      logFile.writeln('[${DateTime.now()}] GET /notes');
      return jsonResponse(200, notes.map((n) => n.toJson()).toList());
    })
    ..get('/notes/<id>', (request, String idStr) {
      logFile.writeln('[${DateTime.now()}] GET /notes/$idStr');
      final id = int.parse(idStr);
      final note = notes.where((n) => n.id == id).firstOrNull;
      if (note == null) return jsonResponse(404, {'error': '未找到'});
      return jsonResponse(200, note.toJson());
    })
    ..post('/notes', (request) async {
      final body = await readJson(request);
      final note = Note(nextId++, body['title'] ?? '', body['content'] ?? '', DateTime.now().toIso8601String());
      notes.add(note);
      logFile.writeln('[${DateTime.now()}] POST /notes -> id=${note.id}');
      return jsonResponse(201, note.toJson());
    })
    ..put('/notes/<id>', (request, String idStr) async {
      final id = int.parse(idStr);
      final idx = notes.indexWhere((n) => n.id == id);
      if (idx == -1) return jsonResponse(404, {'error': '未找到'});
      final body = await readJson(request);
      final old = notes[idx];
      notes[idx] = Note(id, body['title'] ?? old.title, body['content'] ?? old.content, old.createdAt);
      logFile.writeln('[${DateTime.now()}] PUT /notes/$idStr');
      return jsonResponse(200, notes[idx].toJson());
    })
    ..delete('/notes/<id>', (request, String idStr) {
      final id = int.parse(idStr);
      final before = notes.length;
      notes.removeWhere((n) => n.id == id);
      logFile.writeln('[${DateTime.now()}] DELETE /notes/$idStr');
      return jsonResponse(200, {'deleted': before - notes.length > 0});
    });

  final server = await serve(router, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] RESTful API 启动: http://localhost:${server.port}');
  await logFile.flush();
}
