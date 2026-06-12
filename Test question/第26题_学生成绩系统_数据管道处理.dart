// Dart 练习题 — 第26题：学生成绩系统 — 数据管道处理
// 知识点：sync*、async*、Stream、StreamTransformer、Iterable 惰性求值、extension
//
// 用 sync* 和 Stream 构建成绩数据处理管道，支持链式转换和过滤。
// 完成下方 TODO 区域，使 main 函数能正确运行。

import 'dart:async';

// ========== TODO 区域 ==========

/// 1. 定义 GradeRecord 类
///    - final String name
///    - final int score
///    - String get grade → 根据分数返回等级
///      >=90: "优秀"  >=80: "良好"  >=70: "中等"  >=60: "及格"  否则"不及格"
///    - String get level → "A" (>=90) / "B" (>=80) / "C" (>=70) / "D" (>=60) / "F"
///    - 重写 toString → "姓名: score分(等级)"

// TODO: 定义 GradeRecord 类


/// 2. 实现 sync* 生成器 Iterable<GradeRecord> generateStudents(int count)
///    - 生成 count 个学生
///    - 姓名格式: "学生_序号" 如 "学生_001"
///    - 分数随机在 40~100 之间（用 Random，种子固定为 42）
///    - 提示：import 'dart:math'; 用 Random(42)

// TODO: 实现 generateStudents 函数


/// 3. 实现 sync* 生成器 Iterable<GradeRecord> filterByGrade(
///        Iterable<GradeRecord> source, String grade)
///    - 过滤出指定等级的学生
///    - 用 yield* 委托给 source.where

// TODO: 实现 filterByGrade 函数


/// 4. 实现 async* 生成器 Stream<GradeRecord> streamRecords(
///        Iterable<GradeRecord> records)
///    - 把 Iterable 转成 Stream
///    - 每条记录间隔 50ms 发出
///    - 用 Future.delayed 实现延迟

// TODO: 实现 streamRecords 函数


/// 5. 实现 StreamTransformer<GradeRecord, R> mapTransformer<R>(
///        R Function(GradeRecord) transform)
///    - 创建一个 StreamTransformer，对每条数据应用 transform
///    - 提示：用 StreamTransformer.fromHandlers

// TODO: 实现 mapTransformer 函数


/// 6. 给 Iterable<GradeRecord> 加扩展方法：
///    - List<GradeRecord> top(int n) → 取分数最高的前 n 个（降序排列）
///    - Map<String, int> get gradeStats → 统计各等级人数
///    - double get average → 平均分（保留一位小数）
///    - List<GradeRecord> get passed → 及格（>=60）的学生
///    - List<GradeRecord> get failed → 不及格的学生

// TODO: 定义 GradeIterableExtension


// ========== 测试代码（请勿修改）==========

void main() async {
  print('========== 学生成绩系统 — 数据管道处理 ==========\n');

  // ---- 测试1：生成学生数据 ----
  print('--- 测试1：sync* 生成学生数据 ---');
  final students = generateStudents(10).toList();
  for (final s in students) {
    print('  $s');
  }

  // ---- 测试2：惰性求值演示 ----
  print('\n--- 测试2：惰性求值 ---');
  print('  调用 generateStudents(5) 但不遍历...');
  final lazy = generateStudents(5);
  print('  已创建 Iterable，尚未执行生成逻辑 ✅');
  print('  开始遍历:');
  for (final s in lazy) {
    print('    $s');
  }

  // ---- 测试3：过滤管道 ----
  print('\n--- 测试3：过滤管道 ---');
  final all = generateStudents(20).toList();
  final excellent = filterByGrade(all, '优秀').toList();
  final failed = filterByGrade(all, '不及格').toList();
  print('  优秀: ${excellent.length}人');
  for (final s in excellent) {
    print('    $s');
  }
  print('  不及格: ${failed.length}人');
  for (final s in failed) {
    print('    $s');
  }

  // ---- 测试4：Stream 管道 ----
  print('\n--- 测试4：Stream 管道 ---');
  final stream = streamRecords(all).transform(
    mapTransformer<GradeRecord>((r) {
      // 每条记录加个标记
      return GradeRecord(r.name, r.score);
    }),
  );
  int count = 0;
  await for (final r in stream) {
    count++;
    if (count <= 3) print('  收到: $r');
    if (count == 3) print('  ...（共 ${all.length} 条）');
  }
  print('  Stream 处理完成 ✅');

  // ---- 测试5：Stream 链式处理 ----
  print('\n--- 测试5：Stream 链式处理 ---');
  final failedStream = streamRecords(all)
      .where((r) => r.score < 60)
      .map((r) => '🚫 ${r.name} ${r.score}分')
      .transform(mapTransformer<String>((r) => r as String));

  print('  不及格名单（Stream 管道）:');
  await for (final msg in failedStream) {
    print('    $msg');
  }

  // ---- 测试6：extension 方法 ----
  print('\n--- 测试6：extension 方法 ---');
  final data = generateStudents(30).toList();
  print('  班级人数: ${data.length}');
  print('  平均分: ${data.average}');
  print('  等级分布: ${data.gradeStats}');
  print('  前5名:');
  for (final s in data.top(5)) {
    print('    $s');
  }
  print('  及格 ${data.passed.length} 人, 不及格 ${data.failed.length} 人');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 学生成绩系统 — 数据管道处理 ==========
  //
  // --- 测试1：sync* 生成学生数据 ---
  //   学生_001: 81分(良好)
  //   学生_002: 76分(中等)
  //   ...
  //
  // --- 测试2：惰性求值 ---
  //   调用 generateStudents(5) 但不遍历...
  //   已创建 Iterable，尚未执行生成逻辑 ✅
  //   开始遍历:
  //     学生_001: ...
  //     ...
  //
  // --- 测试3：过滤管道 ---
  //   优秀: N人
  //   ...
  //   不及格: N人
  //   ...
  //
  // --- 测试4：Stream 管道 ---
  //   收到: ...
  //   ...
  //
  // --- 测试5：Stream 链式处理 ---
  //   不及格名单（Stream 管道）:
  //   ...
  //
  // --- 测试6：extension 方法 ---
  //   班级人数: 30
  //   平均分: xx.x
  //   等级分布: {优秀: N, 良好: N, ...}
  //   前5名:
  //     ...
  //   及格 N 人, 不及格 N 人
  //
  // ========== 测试完成 ==========
}
