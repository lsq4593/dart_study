// Dart 第四十八课：文件读写 (dart:io)

// ========== 运行前注意 ==========
// dart:io 只能在非 Web 平台使用（CLI、Flutter、服务器）
// 这个文件是所有示例的合集，运行方式：
//   dart run lesson48.dart
// 会创建 lesson48_output/ 目录存放测试文件

import 'dart:io';

void main() async {
  // 创建测试目录
  final dir = Directory('lesson48_output');
  if (!await dir.exists()) {
    await dir.create();
  }

  // ========== 1. 写文件：writeAsString ==========
  // 默认模式 FileMode.write：覆盖写入
  var file1 = File('${dir.path}/hello.txt');
  await file1.writeAsString('Hello, Dart!\n');
  print('✅ 写入完成: ${file1.path}');
  // 追加模式 FileMode.append：在文件末尾追加
  await file1.writeAsString('第二行内容\n', mode: FileMode.append);
  await file1.writeAsString('第三行内容\n', mode: FileMode.append);
  print('✅ 追加完成');

  // ========== 2. 读文件：readAsString ==========
  var content = await file1.readAsString();
  print('\n📖 读取全部内容:');
  print(content);

  // ========== 3. 按行读取：readAsLines ==========
  var lines = await file1.readAsLines();
  print('\n📖 按行读取（共 ${lines.length} 行）:');
  for (int i = 0; i < lines.length; i++) {
    print('  第${i + 1}行: ${lines[i]}');
  }

  // ========== 4. 判断文件是否存在 ==========
  print('\n🔍 检查文件是否存在:');
  print('  hello.txt: ${await File('${dir.path}/hello.txt').exists()}');
  print('  not_exist.txt: ${await File('${dir.path}/not_exist.txt').exists()}');

  // ========== 5. 写二进制：writeAsBytes / readAsBytes ==========
  var file2 = File('${dir.path}/binary.dat');
  var bytes = [0x48, 0x65, 0x6C, 0x6C, 0x6F]; // Hello 的 ASCII 码
  await file2.writeAsBytes(bytes);
  var readBytes = await file2.readAsBytes();
  print('\n🔢 二进制文件:');
  print('  写入: $bytes');
  print('  读取: $readBytes');
  print('  转字符串: ${String.fromCharCodes(readBytes)}');

  // ========== 6. 写入多行：用 IOSink ==========
  // 适合大量写入，不用每次打开关闭文件
  var file3 = File('${dir.path}/sink_test.txt');
  var sink = file3.openWrite();
  for (int i = 1; i <= 100; i++) {
    sink.writeln('第 $i 行数据');
  }
  await sink.close(); // 关闭才真正写入
  var lineCount = (await file3.readAsLines()).length;
  print('\n📝 IOSink 写入: 共 $lineCount 行');

  // ========== 7. 复制文件 ==========
  var copyPath = '${dir.path}/hello_copy.txt';
  await file1.copy(copyPath);
  print('\n📋 复制文件:');
  print('  源文件: ${file1.path}');
  print('  副本: $copyPath');
  print('  内容一致: ${await File(copyPath).readAsString() == content}');

  // ========== 8. 删除文件 ==========
  await File(copyPath).delete();
  print('\n🗑️ 删除副本: ${await File(copyPath).exists() ? "删除失败" : "删除成功"}');

  // ========== 9. 错误处理：try-catch ==========
  print('\n⚠️ 错误处理示例:');
  try {
    await File('${dir.path}/不存在的文件.txt').readAsString();
  } on FileSystemException catch (e) {
    print('  捕获到异常: ${e.message}');
    print('  文件路径: ${e.path}');
  }

  // // ========== 10. 获取文件信息 ==========
  // var stat = await file1.stat();
  // print('\n📊 文件信息:');
  // print('  大小: ${stat.size} 字节');
  // print('  创建时间: ${stat.modified}');
  // print('  修改时间: ${stat.changed}');
  // print('  类型: ${stat.type}');

  // // ========== 清理测试目录 ==========
  // print('\n🧹 清理测试目录...');
  // await dir.delete(recursive: true);
  // print('✅ 清理完成');
}

/*
总结：文件操作核心 API

1. 写入
   writeAsString(content)           — 覆盖写入字符串
   writeAsString(content, mode: append) — 追加写入
   openWrite()                      — 获取 IOSink，适合大量写入

2. 读取
   readAsString()                   — 读取全部文本
   readAsLines()                    — 按行读取，返回 List<String>
   readAsBytes()                    — 读取二进制

3. 文件和目录操作
   File('路径').exists()            — 判断是否存在
   File('路径').copy(目标路径)       — 复制文件
   File('路径').delete()            — 删除文件
   File('路径').rename(新名称)       — 重命名
   Directory('路径').create()        — 创建目录
   Directory('路径').delete()       — 删除目录
   Directory('路径').list()         — 列出目录内容

4. 同步方法（Sync 结尾）
   异步方法去掉 await，加 Sync 后缀：
   readAsStringSync()
   writeAsStringSync()
   readAsLinesSync()
   适合命令行脚本，不适合 Flutter UI

5. 对比

| 操作 | 异步 | 同步 |
|------|------|------|
| 写法 | await file.readAsString() | file.readAsStringSync() |
| 是否阻塞 | ❌ 不阻塞 | ✅ 阻塞 |
| 适合 | Flutter、服务器 | CLI 脚本、小工具 |
*/
