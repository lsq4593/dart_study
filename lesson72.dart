// Dart 第七十二课：shelf 框架入门
// shelf = Dart 官方推荐的 HTTP 服务框架

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main() async {
  final logFile = File('server72.log').openWrite(mode: FileMode.append);
  logFile.writeln('=== shelf 服务器启动 ===');

  // 1. Handler — 一个函数: Request → Response
  Handler handler = (Request request) {
    logFile.writeln('[${DateTime.now()}] ${request.method} ${request.url.path}');

    return Response.ok(
      'Hello from shelf!\n路径: ${request.url.path}\n方法: ${request.method}',
      headers: {'content-type': 'text/plain; charset=utf-8'},
    );
  };

  // 2. 启动 — serve() 对比 HttpServer.bind()
  final server = await serve(handler, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 启动: http://localhost:${server.port}');
  await logFile.flush();
}
