// Dart 第七十七课：数据库连接
// 用 sembast（纯 Dart NoSQL 数据库）实现持久化存储

import "dart:io";
import "package:sembast/sembast_io.dart";

void main() async {
  final logFile = File("server77.log").openWrite(mode: FileMode.append);

  // 1. 打开数据库（不存在则自动创建）
  final db = await databaseFactoryIo.openDatabase("notes_sembast.db");
  final store = StoreRef.main();
  logFile.writeln("[${DateTime.now()}] 数据库已打开");

  // 2. CREATE — 插入数据（add 返回自增 key）
  var k1 = await store.add(db, {
    "title": "学习Dart", "content": "基础语法",
    "createdAt": DateTime.now().toIso8601String(),
  });
  var k2 = await store.add(db, {
    "title": "购物清单", "content": "苹果、牛奶",
    "createdAt": DateTime.now().toIso8601String(),
  });
  logFile.writeln("[${DateTime.now()}] 创建: key=$k1, key=$k2");

  // 3. READ — 查询全部
  var all = await store.find(db);
  logFile.writeln("=== 全部记录 (${all.length}条) ===");
  for (var r in all) {
    var v = r.value as Map<String, dynamic>;
    logFile.writeln("  #${r.key}: ${v["title"]} — ${v["content"]}");
  }

  // 4. READ — 查询单个
  var single = await store.find(db, finder: Finder(filter: Filter.byKey(k1)));
  var sv = single.first.value as Map<String, dynamic>;
  logFile.writeln("单条 #$k1: ${sv["title"]}");

  // 5. UPDATE — 更新
  await store.record(k1).update(db, {
    "title": "学Flutter", "content": "已进阶到Flutter",
  });
  var updated = await store.find(db, finder: Finder(filter: Filter.byKey(k1)));
  var uv = updated.first.value as Map<String, dynamic>;
  logFile.writeln("更新 #$k1: ${uv["title"]} — ${uv["content"]}");

  // 6. DELETE — 删除
  await store.record(k2).delete(db);
  var count = await store.count(db);
  logFile.writeln("删除 #$k2 后剩余: $count 条");

  // 7. 关闭
  await db.close();
  logFile.writeln("[${DateTime.now()}] 数据库已关闭");
  await logFile.flush();

  // 展示日志
  print(await File("server77.log").readAsString());
}
