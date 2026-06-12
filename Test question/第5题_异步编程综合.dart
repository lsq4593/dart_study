// Dart 全课程综合练习题 — 第5题
// 知识点：Future、async/await、Stream、StreamController、Completer、Future.wait、Isolate、Timer

import 'dart:async';
import 'dart:isolate';

// TODO: 实现以下功能

// 1. 用 Completer 包装一个回调风格的函数
void loadConfig(void Function(String) onOk, void Function(Object) onErr) {
  Future.delayed(Duration(milliseconds: 500), () => onOk('config: {darkMode: true}'));
}
Future<String> loadConfigAsync() {
  // TODO: 用 Completer 包装
  throw UnimplementedError();
}

// 2. 用 Future.wait 同时加载用户信息和配置信息
Future<String> fetchUser() async {
  await Future.delayed(Duration(milliseconds: 600));
  return '用户信息';
}
Future<String> fetchConfig() async {
  await Future.delayed(Duration(milliseconds: 400));
  return '配置信息';
}
Future<(String, String)> loadAll() async {
  // TODO: 用 Future.wait 并行加载
  throw UnimplementedError();
}

// 3. 用 Stream.periodic 做一个倒计时 Stream，到 0 时结束
Stream<int> countdown(int seconds) {
  // TODO: 实现
  throw UnimplementedError();
}

// 4. 用 StreamController 手动控制流（发出 3 条消息后关闭）
Stream<String> createMessageStream() {
  // TODO: 实现
  throw UnimplementedError();
}

// 5. 用 Isolate 计算斐波那契数列（不阻塞主线程）
Future<int> fibonacciInIsolate(int n) async {
  // TODO: 用 Isolate.run 实现
  throw UnimplementedError();
}

// 6. 用 Timer.periodic 实现每隔 1 秒打印一次当前时间，共 5 次

void main() async {
  print('1. Completer 包装: ${await loadConfigAsync()}');
  
  var (user, config) = await loadAll();
  print('2. 并行加载: $user, $config');
  
  print('3. 倒计时:');
  await for (var n in countdown(5)) {
    print('   $n');
  }
  
  print('4. 消息流:');
  await for (var msg in createMessageStream()) {
    print('   $msg');
  }
  
  var fib = await fibonacciInIsolate(40);
  print('5. fib(40) = $fib');
  
  print('6. 定时器:');
  // TODO: Timer.periodic 打印时间 5 次
}
