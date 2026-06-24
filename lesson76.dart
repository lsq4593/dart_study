// Dart 第七十六课：中间件模式
// 中间件 = 包裹 Handler 的函数，在请求前后插⼊逻辑

import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// ──── 三个中间件 ────

// 1. 日志 — 记录方法和耗时
Middleware logMiddleware(IOSink log) {
  return (innerHandler) => (request) async {
    final sw = Stopwatch()..start();
    final response = await innerHandler(request);
    log.writeln('[${DateTime.now()}] ${request.method} ${request.url.path} -> ${response.statusCode} (${sw.elapsedMilliseconds}ms)');
    await log.flush();
    return response;
  };
}

// 2. CORS — 加跨域头
Middleware corsMiddleware() {
  return (innerHandler) => (request) async {
    if (request.method == 'OPTIONS') return Response(204, headers: _cors);
    final response = await innerHandler(request);
    return response.change(headers: {...response.headers, ..._cors});
  };
}
const _cors = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'access-control-allow-headers': 'Content-Type, Authorization',
};

// 3. 鉴权 — 检查 Bearer token
Middleware authMiddleware() {
  return (innerHandler) => (request) async {
    // 公开路径不检查
    if (request.url.path == 'public') return innerHandler(request);
    final auth = request.headers['authorization'];
    if (auth == null || !auth.startsWith('Bearer ')) {
      return Response(401, body: '{"error":"需要 Bearer token"}',
          headers: {'content-type': 'application/json'});
    }
    // 把用户信息放进 context
    return innerHandler(request.change(context: {'user': 'user_${auth.substring(7)}'}));
  };
}

// ──── 路由 ────

void main() async {
  final logFile = File('server76.log').openWrite(mode: FileMode.append);

  final router = Router()
    ..get('/public', (request) {
      logFile.writeln('[${DateTime.now()}] 公开接口被访问');
      return Response.ok('{"data": "公开数据"}',
          headers: {'content-type': 'application/json'});
    })
    ..get('/private', (request) {
      final user = request.context['user'] ?? 'anonymous';
      logFile.writeln('[${DateTime.now()}] 私密接口被访问: user=$user');
      return Response.ok('{"data": "私密数据", "user": "$user"}',
          headers: {'content-type': 'application/json'});
    });

  // Pipeline: 日志 → CORS → 鉴权 → 路由
  final handler = Pipeline()
    .addMiddleware(logMiddleware(logFile))
    .addMiddleware(corsMiddleware())
    .addMiddleware(authMiddleware())
    .addHandler(router);

  final server = await serve(handler, 'localhost', 8080);
  logFile.writeln('[${DateTime.now()}] 启动: http://localhost:${server.port}');
  await logFile.flush();
}
