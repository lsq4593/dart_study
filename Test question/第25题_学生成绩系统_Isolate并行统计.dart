// Dart 练习题 — 第25题：学生成绩系统 — Isolate 并行统计
// 知识点：Isolate、SendPort/ReceivePort、Future.wait、dart:math、Stopwatch
//
// 用 Isolate 并行计算多个班级的成绩统计，对比串行与并行的性能差异。
// 完成下方 TODO 区域，使 main 函数能正确运行。

import 'dart:async';
import 'dart:isolate';
import 'dart:math';

// ========== TODO 区域 ==========

/// 1. 定义 ClassReport 类（成绩报告）
///    - final String className
///    - final double avg
///    - final int highest
///    - final int lowest
///    - final int passedCount
///    - final int failedCount
///    - final int totalStudents
///    - String get summary → 格式化的报告摘要
///      格式: "[班级名] 平均分:avg 最高:high 最低:low 及格:passed/共:total"
///    - factory ClassReport.fromMap(Map<String, dynamic> map) — 从 Map 构造
///    - Map<String, dynamic> toJson() — 转成 Map

// TODO: 实现 ClassReport 类


/// 2. 实现函数 Map<String, int> generateClass(String name, int count, Random rng)
///    生成一个班级的成绩数据
///    - 班级名称为 "第X班"（X 从 1 开始）
///    - 生成 count 个学生，成绩在 30~100 之间随机
///    - 学生姓名格式: "S_班级编号_序号"，如 "S_01_001"
///    - 返回 Map<String, int>（姓名 → 分数）

// TODO: 实现 generateClass 函数


/// 3. 实现函数 ClassReport calculateReport(Map<String, int> classScores)
///    计算单个班级的统计报告

// TODO: 实现 calculateReport 函数


/// 4. 实现 Isolate 入口函数 void isolateWorker(SendPort sendPort)
///    - 创建 ReceivePort 接收主 Isolate 发来的数据
///    - 把 sendPort 发给主 Isolate，建立双向通信
///    - 收到 Map<String, int> 后，调用 calculateReport 计算
///    - 把 ClassReport 的 toJson() Map 发回主 Isolate
///    - 提示：用 ReceivePort 的 first 等待主 Isolate 发数据

// TODO: 实现 isolateWorker 函数


/// 5. 实现函数 Future<List<ClassReport>> runParallel(
///        List<Map<String, int>> allClasses)
///    - 为每个班级启动一个 Isolate
///    - 把班级数据发给对应的 Isolate
///    - 收集所有 Isolate 返回的结果
///    - 用 Future.wait 等待所有 Isolate 完成
///    - 返回 List<ClassReport>

// TODO: 实现 runParallel 函数


/// 6. 实现函数 List<ClassReport> runSequential(
///        List<Map<String, int>> allClasses)
///    - 在主 Isolate 中依次计算每个班级的报告
///    - 返回 List<ClassReport>

// TODO: 实现 runSequential 函数


// ========== 测试代码（请勿修改）==========

void main() async {
  print('========== 学生成绩系统 — Isolate 并行统计 ==========\n');

  final rng = Random(42); // 固定种子，结果可复现

  // ---- 准备数据：生成 8 个班，每班 30 人 ----
  print('--- 准备数据 ---');
  final allClasses = <Map<String, int>>[];
  for (int i = 1; i <= 8; i++) {
    final cls = generateClass(i, 30, rng);
    allClasses.add(cls);
    print('  第${i}班: ${cls.length}人');
  }
  print('  共 ${allClasses.length} 个班级');

  // ---- 测试1：串行计算 ----
  print('\n--- 测试1：串行计算 ---');
  var sw = Stopwatch()..start();
  final seqResults = runSequential(allClasses);
  sw.stop();
  for (final r in seqResults) {
    print('  ${r.summary}');
  }
  print('  串行耗时: ${sw.elapsedMilliseconds}ms');

  // ---- 测试2：并行计算 ----
  print('\n--- 测试2：并行计算 ---');
  sw.reset();
  sw.start();
  final parResults = await runParallel(allClasses);
  sw.stop();
  for (final r in parResults) {
    print('  ${r.summary}');
  }
  print('  并行耗时: ${sw.elapsedMilliseconds}ms');

  // ---- 测试3：结果一致性验证 ----
  print('\n--- 测试3：结果一致性验证 ---');
  bool match = true;
  for (int i = 0; i < seqResults.length; i++) {
    if (seqResults[i].avg != parResults[i].avg ||
        seqResults[i].highest != parResults[i].highest ||
        seqResults[i].lowest != parResults[i].lowest) {
      match = false;
      print('  第${i + 1}班结果不一致!');
    }
  }
  print('  串行与并行结果${match ? "一致 ✅" : "不一致 ❌"}');

  // ---- 测试4：超大数据量 ----
  print('\n--- 测试4：超大数据量（模拟）---');
  final bigClasses = <Map<String, int>>[];
  for (int i = 1; i <= 4; i++) {
    bigClasses.add(generateClass(i, 50000, rng));
  }
  print('  4 个班级，每班 50000 人');

  sw.reset();
  sw.start();
  runSequential(bigClasses);
  sw.stop();
  print('  串行耗时: ${sw.elapsedMilliseconds}ms');

  sw.reset();
  sw.start();
  await runParallel(bigClasses);
  sw.stop();
  print('  并行耗时: ${sw.elapsedMilliseconds}ms');
  print('  🎉 数据量越大，并行优势越明显!');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考，具体数值因随机种子而异）：
  // ========== 学生成绩系统 — Isolate 并行统计 ==========
  //
  // --- 准备数据 ---
  //   第1班: 30人
  //   第2班: 30人
  //   ...
  //   共 8 个班级
  //
  // --- 测试1：串行计算 ---
  //   [第1班] 平均分:xx.x 最高:xx 最低:xx 及格:xx/共:30
  //   [第2班] 平均分:xx.x 最高:xx 最低:xx 及格:xx/共:30
  //   ...
  //   串行耗时: xxms
  //
  // --- 测试2：并行计算 ---
  //   [第1班] 平均分:xx.x 最高:xx 最低:xx 及格:xx/共:30
  //   ...
  //   并行耗时: xxms
  //
  // --- 测试3：结果一致性验证 ---
  //   串行与并行结果一致 ✅
  //
  // --- 测试4：超大数据量 ---
  //   4 个班级，每班 50000 人
  //   串行耗时: xxms
  //   并行耗时: xxms
  //   🎉 数据量越大，并行优势越明显!
  //
  // ========== 测试完成 ==========
}
