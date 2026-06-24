// Dart 第七十五课：静态文件服务
// 用 shelf_static 托管前端文件

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

void main() async {
  final logFile = File('server75.log').openWrite(mode: FileMode.append);

  // 1. API 路由
  final router = Router()
    ..get('/api/hello', (request) {
      logFile.writeln('[${DateTime.now()}] API: /api/hello');
      return Response.ok('{"message": "Hello from Dart"}',
          headers: {'content-type': 'application/json'});
    });

  // 2. 静态文件 — public/ 目录
  final staticHandler = createStaticHandler('public',
    defaultDocument: 'index.html',
  );

  // 3. Cascade: 先 API → 没匹配上 → 静态文件
  final handler = Cascade().add(router).add(staticHandler).handler;

  final server = await serve(handler, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 启动: http://localhost:${server.port}');
  await logFile.flush();
}
