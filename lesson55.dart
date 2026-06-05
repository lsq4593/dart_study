// Dart 第五十五课：Process 进程（执行系统命令）

import 'dart:io';
import 'dart:convert';
import 'dart:async';

Future<void> main() async {
  print('========== Process 进程 ==========');

  // ========== 1. Process.run：一次性执行 ==========
  print('\n--- 1. 查看 Dart 版本 ---');
  var r1 = await Process.run('dart', ['--version']);
  print('exitCode: ${r1.exitCode}');
  print('stdout: ${r1.stdout}');

  // ========== 2. 执行失败的处理 ==========
  print('\n--- 2. 处理错误 ---');
  var r2 = await Process.run('dart', ['nonexistent-command']);
  print('exitCode: ${r2.exitCode}'); // 非0
  print('stderr: ${r2.stderr}');

  // ========== 3. 带参数执行 ==========
  print('\n--- 3. 模拟 git status（仅演示语法） ---');
  // 检查 git 是否可用
  var gitCheck = await Process.run('git', ['--version']);
  if (gitCheck.exitCode == 0) {
    print('git 可用: ${gitCheck.stdout}');
  } else {
    print('git 不可用');
  }

  // ========== 4. Process.start：流式实时输出 ==========
  print('\n--- 4. 逐行输出（cmd echo） ---');
  try {
    var p4 = await Process.start('dart', ['analyze', '--help']);

    await for (var line
        in p4.stdout.transform(utf8.decoder).transform(const LineSplitter())) {
      print('  $line');
    }

    var code = await p4.exitCode;
    print('退出码: $code');
  } catch (e) {
    print('  执行失败: $e');
  }

  // ========== 5. 向进程写入输入 ==========
  print('\n--- 5. 向进程输入数据 ---');
  try {
    var p5 = await Process.start('findstr', ['hello']);

    // 向 stdin 写入数据
    p5.stdin.writeln('hello world');
    p5.stdin.writeln('goodbye');
    p5.stdin.writeln('hello again');
    await p5.stdin.close();

    // 读取输出
    var output = await p5.stdout.transform(utf8.decoder).join();
    print('  findstr 输出:');
    print('  $output');

    await p5.exitCode;
  } catch (e) {
    print('  findstr 执行失败: $e');
  }

  // ========== 6. 超时控制 ==========
  print('\n--- 6. 超时控制 ---');
  try {
    var r6 = await Process.run('cmd', [
      '/c',
      'ping -n 10 127.0.0.1',
    ]).timeout(Duration(seconds: 2));
    print('完成: ${r6.stdout}');
  } on TimeoutException {
    print('  命令超时了（2秒）');
  }

  // ========== 7. 获取系统信息 ==========
  print('\n--- 7. 获取系统信息 ---');

  // 环境变量
  print('  PATH: ${Platform.environment['PATH']?.substring(0, 60)}...');
  print('  操作系统: ${Platform.operatingSystem}');
  print('  Dart 版本: ${Platform.version}');
  print('  当前目录: ${Directory.current.path}');

  // ========== 8. 链式执行命令 ==========
  print('\n--- 8. 查看当前目录内容 ---');
  if (Platform.isWindows) {
    var dir = await Process.run('cmd', ['/c', 'dir', '/b']);
    print('  当前目录:\n${dir.stdout}');
    print('走的这里');
  } else {
    var ls = await Process.run('ls', ['-la']);
    print('  当前目录:\n${ls.stdout}');
  }

  print('\n程序结束');
}

/*
总结：Process 进程

1. Process.run — 简单命令
   await Process.run('命令', ['参数'])
   返回 stdout / stderr / exitCode

2. Process.start — 实时交互
   await Process.start('命令', ['参数'])
   返回 process 对象，可读写 stdin/stdout/stderr

3. 解码 stdout
   stdout.transform(utf8.decoder)              → String
   stdout.transform(utf8.decoder).transform(LineSplitter()) → 逐行

4. 控制
   process.kill()        → 终止进程
   process.stdin.write   → 向进程输入
   process.exitCode      → 等待结束

5. 超时
   Process.run(...).timeout(Duration(秒))

6. 平台判断
   Platform.isWindows
   Platform.isLinux
   Platform.isMacOS
   Platform.environment['PATH']  → 环境变量
*/
