// Dart 第三十九课：多 Isolate 并发

import 'dart:isolate';

void main() async {
  print('=== 同时启动 3 个线程 ===\n');

  // 同时启动，各自完成后立刻打印
  Isolate.run(() => heavyWork('线程1', 35)).then(print);
  Isolate.run(() => heavyWork('线程2', 40)).then(print);
  Isolate.run(() => heavyWork('线程3', 30)).then(print);

  // 等一会，不然 main 直接结束了
  await Future.delayed(Duration(seconds: 2));
  print('\n主线程结束');
}

String heavyWork(String name, int n) {
  var start = DateTime.now();
  var result = fibonacci(n);
  var elapsed = DateTime.now().difference(start).inMilliseconds;
  return '$name: fib($n)=$result, 耗时 ${elapsed}ms';
}

int fibonacci(int n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}
