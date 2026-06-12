// Dart 全课程综合练习题 — 第13题
// 知识点：Stream/StreamController、map/where/distinct/take/skip/timeout/transform、广播流、debounce/throttle

import 'dart:async';

// TODO: 实现一个搜索框防抖模拟

// 1. 用 StreamController 模拟用户输入（每次间隔 200ms 发出一个字符）
// 2. 用 Stream 操作符实现：
//    - distinct() — 连续相同的输入去重
//    - 自定义 debounce — 用户停止输入 500ms 后才发出
//    - map — 把输入转成搜索请求格式 "搜索: xxx"
// 3. 用 StreamTransformer 实现一个日志转换器
//    给每条数据加上时间戳 "[HH:mm:ss] 数据"
// 4. 用广播流让两个监听者同时收到数据

// TODO: 自定义 debounce StreamTransformer
StreamTransformer<T, T> debounce<T>(Duration duration) {
  // 提示：用 Timer 实现，每次收到新数据重置 Timer
  throw UnimplementedError();
}

// TODO: 自定义日志转换器
StreamTransformer<String, String> logTransformer() {
  // 提示：给每条数据加时间戳前缀
  throw UnimplementedError();
}

void main() async {
  print('模拟用户输入搜索...');
  
  // 模拟用户输入: 每 200ms 输入一个字符
  var inputs = ['h', 'he', 'hel', 'hell', 'hello'];
  var controller = StreamController<String>();
  
  // 添加输入数据（每 200ms 一个）
  for (var i = 0; i < inputs.length; i++) {
    Future.delayed(Duration(milliseconds: 200 * i), () => controller.add(inputs[i]));
  }
  Future.delayed(Duration(milliseconds: 200 * inputs.length), () => controller.close());
  
  // TODO: 
  // 1. 用 controller.stream 加工
  // 2. 用 distinct() 去重
  // 3. 用 debounce(Duration(milliseconds: 500)) 防抖
  // 4. 用 logTransformer() 加日志时间戳
  // 5. map 转成搜索请求格式
  // 6. 用 asBroadcastStream() 让两个监听者同时收到
  
  // 监听者1
  // controller.stream.listen((data) => print('监听者1: $data'));
  
  // 监听者2
  // controller.stream.listen((data) => print('监听者2: $data'));
  
  await Future.delayed(Duration(seconds: 2));
}
