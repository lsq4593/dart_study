// Dart 全课程综合练习题 — 第17题
// 知识点：Uri、Process、Directory、File、Platform

import 'dart:io';
import 'dart:convert';

// TODO: 实现以下功能

// 1. 写一个函数 parseUrl(String url)，用 Uri 解析并打印各部分
//    - scheme, host, port, path, query, fragment

// 2. 用 Process.run 执行系统命令（如 dart --version、dir/ls）

// 3. 写一个递归遍历目录的函数，输出树形结构
//    示例输出：
//    lib/
//    ├── src/
//    │   ├── main.dart
//    │   └── utils.dart
//    └── test/
//        └── test.dart

// 4. 用 Directory.watch 监听文件变化，持续 5 秒后取消

void parseUrl(String url) {
  // TODO
}

Future<void> runSystemCommand(String command, List<String> args) async {
  // TODO
}

void printDirectoryTree(Directory dir, {String prefix = ''}) {
  // TODO
}

void main() async {
  print('=== 1. 解析 URL ===');
  parseUrl('https://user:pass@example.com:8080/path/to/page?name=dart&version=3.0#section2');

  print('\n=== 2. 执行系统命令 ===');
  await runSystemCommand('dart', ['--version']);

  print('\n=== 3. 目录树 ===');
  var dir = Directory('${Directory.current.path}');
  printDirectoryTree(dir);

  print('\n=== 4. 监听文件变化（5秒） ===');
  var watchDir = Directory.systemTemp.createTemp('watch_test');
  var sub = watchDir.watch().listen((event) {
    print('变化: ${event.type} - ${event.path}');
  });

  await File('${watchDir.path}/test.txt').create();
  await Future.delayed(Duration(seconds: 1));
  await File('${watchDir.path}/test.txt').writeAsString('hello');

  await Future.delayed(Duration(seconds: 5));
  await sub.cancel();
  await watchDir.delete(recursive: true);
}
