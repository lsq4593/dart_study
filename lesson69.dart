// Dart 第六十九课：dart:io 深入 — 目录操作

import 'dart:io';

void main() async {
  print('========== 目录操作 ==========');

  // 测试目录
  var testDir = Directory('${Directory.current.path}/test_workdir');
  if (await testDir.exists()) {
    await testDir.delete(recursive: true);
  }

  // ========== 1. 创建目录 ==========
  print('\n--- 1. 创建目录 ---');
  // 🏛️ dart:io API — Directory.create / createSync

  await testDir.create();
  print('  创建: ${testDir.path}');

  var nestedDir = Directory('${testDir.path}/a/b/c');
  await nestedDir.create(recursive: true);
  print('  多级创建: ${nestedDir.path}');

  // ========== 2. 判断存在 ==========
  print('\n--- 2. 判断存在 ---');
  // 🏛️ dart:io API — Directory.exists / existsSync

  print('  存在? ${await testDir.exists()}');
  print('  不存在? ${await Directory('no_dir').exists()}');

  // ========== 3. 列出目录内容 ==========
  print('\n--- 3. 列出目录内容 ---');
  // 🏛️ dart:io API — Directory.list

  // 创建测试文件
  await File('${testDir.path}/a.txt').create();
  await File('${testDir.path}/b.txt').create();
  await File('${testDir.path}/c.json').create();
  await Directory('${testDir.path}/sub').create();

  await for (var entity in testDir.list()) {
    var name = entity.path.split(Platform.pathSeparator).last;
    print('  ${entity.runtimeType} → $name');
  }

  // ========== 4. 递归遍历并过滤 ==========
  print('\n--- 4. 递归遍历 + 过滤 ---');
  // 🏛️ dart:io API — Directory.list(recursive: true)

  await for (var entity in testDir.list(recursive: true)) {
    var name = entity.path.split(Platform.pathSeparator).last;
    if (name.endsWith('.txt')) {
      print('  .txt 文件: $name');
    }
  }

  // ========== 5. 计算目录大小 ==========
  print('\n--- 5. 计算目录大小 ---');
  // 🏛️ dart:io API — File.stat

  int totalSize = 0;
  await for (var entity in testDir.list(recursive: true)) {
    if (entity is File) {
      totalSize += (await entity.stat()).size;
    }
  }
  print('  总大小: $totalSize bytes');

  // ========== 6. 复制目录（手动递归） ==========
  print('\n--- 6. 复制目录 ---');

  var targetDir = Directory('${testDir.path}_copy');
  await _copyDir(testDir, targetDir);
  print('  复制完成: ${targetDir.path}');

  // ========== 7. 重命名/移动 ==========
  print('\n--- 7. 重命名 ---');
  // 🏛️ dart:io API — Directory.rename

  var renamedDir = Directory('${testDir.path}_renamed');
  await testDir.rename(renamedDir.path);
  print('  新路径: ${renamedDir.path}');

  // ========== 8. 删除 ==========
  print('\n--- 8. 删除目录 ---');
  // 🏛️ dart:io API — Directory.delete(recursive)

  await targetDir.delete(recursive: true);
  await renamedDir.delete(recursive: true);
  print('  已清理');

  // ========== 9. 系统目录 ==========
  print('\n--- 9. 系统目录 ---');
  // 🏛️ dart:io API — Directory.current / Directory.systemTemp

  print('  当前目录: ${Directory.current.path}');
  print('  临时目录: ${Directory.systemTemp.path}');

  // ========== 10. 实用：批量重命名 ==========
  print('\n--- 10. 批量重命名 ---');

  var batchDir = Directory('${Directory.systemTemp.path}/dart_rename');
  await batchDir.create();

  for (int i = 1; i <= 5; i++) {
    await File('${batchDir.path}/photo_$i.jpg').create();
  }

  await for (var entity in batchDir.list()) {
    if (entity is File && entity.path.endsWith('.jpg')) {
      var oldName = entity.path.split(Platform.pathSeparator).last;
      var newName = oldName.replaceAll('photo_', 'img_');
      await entity.rename('${batchDir.path}/$newName');
      print('  $oldName → $newName');
    }
  }

  await batchDir.delete(recursive: true);

  // ========== 11. 实用：监听目录变化 ==========
  print('\n--- 11. 监听目录变化 ---');
  // 🏛️ dart:io API — Directory.watch

  var watchDir = Directory('${Directory.systemTemp.path}/dart_watch');
  await watchDir.create();

  var sub = watchDir.watch().listen((event) {
    var name = event.path.split(Platform.pathSeparator).last;
    print('  事件: ${event.type} → $name');
  });

  await File('${watchDir.path}/new.txt').create();
  await Future.delayed(const Duration(milliseconds: 50));
  await File('${watchDir.path}/new.txt').writeAsString('hi');
  await Future.delayed(const Duration(milliseconds: 50));
  await File('${watchDir.path}/new.txt').delete();
  await Future.delayed(const Duration(milliseconds: 50));

  await sub.cancel();
  await watchDir.delete(recursive: true);
  print('  监听结束');

  print('\n程序结束');
}

/// 递归复制目录
Future<void> _copyDir(Directory src, Directory dst) async {
  await dst.create(recursive: true);
  await for (var entity in src.list()) {
    var name = entity.path.split(Platform.pathSeparator).last;
    if (entity is File) {
      await entity.copy('${dst.path}/$name');
    } else if (entity is Directory) {
      await _copyDir(entity, Directory('${dst.path}/$name'));
    }
  }
}

/*
总结：目录操作（dart:io）

🏛️ dart:io API

创建/判断：create()、create(recursive)、exists()
遍历：list()、list(recursive: true)
增删改：rename()、delete(recursive)
系统目录：Directory.current、Directory.systemTemp
监听变化：watch() → Stream<FileSystemEvent>

注意：
- 删除非空目录必须 recursive: true
- 创建多级目录必须 recursive: true
- watch() 需手动 cancel()
*/
