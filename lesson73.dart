// Dart 第七十三课：路由与参数
// 用 shelf_router 替代手写 if-else 分发

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final logFile = File('server73.log').openWrite(mode: FileMode.append);

  final router = Router()
    ..get('/', (request) {
      return Response.ok('首页', headers: utf8Headers);
    })
    ..get('/hello', (request) {
      return Response.ok('你好!', headers: utf8Headers);
    })
    // 路径参数: <name> 自动提取→String name
    ..get('/hello/<name>', (request, String name) {
      return Response.ok('你好, $name!', headers: utf8Headers);
    })
    // 查询参数: ?q=xxx
    ..get('/search', (request) {
      final q = request.url.queryParameters['q'] ?? '(空)';
      return Response.ok('搜索: $q', headers: utf8Headers);
    })
    // POST 读取请求体
    ..post('/data', (request) async {
      final body = await request.readAsString();
      return Response.ok('收到: $body', headers: utf8Headers);
    })
    // 多段路径参数
    ..get('/users/<id>/posts', (request, String id) {
      return Response.ok('用户 $id 的帖子', headers: utf8Headers);
    });

  // 中间件：写文件日志
  final handler = Pipeline().addMiddleware(
    (innerHandler) => (request) async {
      logFile.writeln('[${DateTime.now()}] ${request.method} ${request.url.path}');
      await logFile.flush();
      return innerHandler(request);
    },
  ).addHandler(router);

  final server = await serve(handler, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 启动: http://localhost:${server.port}');
  await logFile.flush();
}

const utf8Headers = {'content-type': 'text/plain; charset=utf-8'};
