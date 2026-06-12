// Dart 全课程综合练习题 — 第18题
// 知识点：sync*/async*生成器、Iterable惰性求值、Stream transform、正则表达式

import 'dart:async';
import 'dart:io';

// TODO: 模拟一个日志文件分析器

// 1. 用 sync* 生成模拟日志行
//    格式: [2026-06-11 10:00:00] [INFO/ERROR] 消息内容
// 2. 用 Iterable 的 where/map 过滤出 ERROR 级别的日志
// 3. 用 RegExp 从日志行中提取时间、级别、消息
// 4. 用 Stream 和 async* 实现异步日志处理（每 300ms 发一条）
// 5. 用 StreamTransformer 实现日志格式化（加颜色标记模拟）
// 6. 用 take(10) 只取前 10 条

// TODO: sync* 生成模拟日志
Iterable<String> generateLogLines(int count) sync* {
  // 随机生成 INFO 或 ERROR 日志
  // 格式: [2026-06-11 10:00:00] [INFO] 用户登录成功
}

// TODO: 提取日志信息
class LogEntry {
  final DateTime time;
  final String level;
  final String message;
  LogEntry(this.time, this.level, this.message);
}

// TODO: 用 RegExp 解析日志行
LogEntry? parseLogLine(String line) {
  // 正则: \[(.*?)\] \[(.*?)\] (.*)
}

// TODO: async* 实现异步日志流
Stream<LogEntry> logStream(Iterable<String> lines) async* {
  // 每 300ms 发一条
}

// TODO: StreamTransformer 日志格式化
StreamTransformer<LogEntry, String> formatTransformer() {
  // 给 ERROR 加 "[ERROR]" 前缀标记
}

void main() async {
  var lines = generateLogLines(20);
  
  // 用 Iterable 操作
  var errorLines = lines.where((line) => line.contains('[ERROR]')).take(5);
  print('=== ERROR 日志（Iterable）===');
  for (var line in errorLines) {
    print(line);
  }
  
  // 用 Stream 异步处理
  print('\n=== 异步日志流 ===');
  var stream = logStream(generateLogLines(15))
      .transform(formatTransformer())
      .take(10);
  
  await for (var formatted in stream) {
    print(formatted);
  }
}
