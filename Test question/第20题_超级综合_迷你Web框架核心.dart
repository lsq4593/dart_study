// Dart 全课程综合练习题 — 第20题（终极挑战）
// 知识点：综合运用全部知识点 — 迷你 Web 框架核心

import 'dart:async';
import 'dart:mirrors';

/*
这道题是终极挑战，请结合你学过的所有知识来设计。

实现一个迷你 Web 框架的核心概念：

1. 泛型 Request<T> / Response<T>
   - Request: method, path, headers, body (T)
   - Response: statusCode, headers, body (T)

2. sealed class Result — 统一返回结果
   - Success(data)
   - Failure(message, code)

3. Middleware 中间件链
   - typedef Middleware = Future<Response> Function(Request)
   - 支持多个中间件串联（用 Iterable + 级联）

4. 路由表（用注解 + Map）
   - @Route(path, method) 注解
   - 反射读取路由表

5. 错误处理（用 Zone）
   - 每个请求在一个独立 Zone 中运行
   - zoneValues 透传 requestId
   - onError 兜底

6. 异步处理（Future + Completer）
   - 请求处理支持异步

7. 不可变配置（copyWith + final class）
   - AppConfig: host, port, timeout

8. 扩展方法（extension on String）
   - String 扩展：解析路径参数 /users/:id
*/

// TODO: 实现你的迷你 Web 框架

void main() {
  print('=== 迷你 Web 框架 ===');
  print('这是一道开放式题目，尽情发挥你的创意！');
  print('包含知识点：泛型、sealed class、注解、反射、Zone、Future、Completer、');
  print('           copyWith、extension、typedef、模式匹配、空安全...');
}
