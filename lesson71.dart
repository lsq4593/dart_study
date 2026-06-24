// Dart 第七十一课：HttpServer 基础
// 用 dart:io 创建一个最简单的 HTTP 服务器
// 日志写入 server.log 文件，方便查看

import 'dart:io';
import 'dart:convert';

void main() async {
  // 日志文件
  final logFile = File('server.log').openWrite(mode: FileMode.append);
  logFile.writeln('=== 服务器启动 ===');

  // 1. 创建 HttpServer，绑定到 localhost:8080
  final server = await HttpServer.bind('localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 服务器已启动: http://localhost:${server.port}');

  // 2. 循环处理每个请求
  await for (final request in server) {
    final method = request.method;
    final path = request.uri.path;

    logFile.writeln('[${DateTime.now()}] $method $path');
    await logFile.flush();  // 每条日志立即写入，不掉缓存

    if (method == 'GET' && path == '/hello') {
      _handleHello(request);
    } else if (method == 'POST' && path == '/echo') {
      await _handleEcho(request);
    } else if (path == '/') {
      _handleRoot(request);
    } else {
      _handleNotFound(request);
    }
  }

  await logFile.close();
}

void _handleHello(HttpRequest request) {
  final name = request.uri.queryParameters['name'] ?? '访客';
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.text
    ..write('你好, $name! 这是 Dart 服务器。')
    ..close();
}

Future<void> _handleEcho(HttpRequest request) async {
  final body = await utf8.decodeStream(request);
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write('{"echo": "$body"}')
    ..close();
}

void _handleRoot(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.html
    ..write('''
      <h1>Dart 服务器</h1>
      <p>试试: <a href="/hello">/hello</a></p>
      <p>试试: <a href="/hello?name=小明">/hello?name=小明</a></p>
    ''')
    ..close();
}

void _handleNotFound(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..write('404 Not Found')
    ..close();
}
