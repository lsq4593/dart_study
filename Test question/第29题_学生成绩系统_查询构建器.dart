// Dart 练习题 — 第29题：学生成绩系统 — 查询构建器
// 知识点：callable class、typedef、运算符重载、泛型、NoSuchMethod、级联
//
// 实现一个类型安全的成绩查询构建器，支持链式 API 和动态查询。
// 完成下方 TODO 区域，使 main 函数能正确运行。

import 'dart:collection';

// ========== TODO 区域 ==========

/// 1. 定义 Student 数据类（不可变）
///    - final String name
///    - final int score
///    - final int age
///    - final String grade (年级)
///    - const 构造函数
///    - 重写 toString → "姓名(score分, age岁, grade)"

// TODO: 定义 Student 类


/// 2. 定义 typedef 过滤器类型
///    - typedef StudentFilter = bool Function(Student)
///
///    定义 callable 类作为过滤器：
///    - class ScoreFilter 接收 int min, int max，call 检查 student.score
///    - class GradeFilter 接收 String grade，call 检查 student.grade
///    - class NameFilter 接收 String keyword，call 检查是否包含关键字

// TODO: 定义 typedef 和过滤器类


/// 3. 给 StudentFilter 加扩展方法：
///    - StudentFilter operator &(StudentFilter other) → 且（两个都满足）
///    - StudentFilter operator |(StudentFilter other) → 或（满足一个即可）
///    - StudentFilter operator !() → 非（取反）
///    提示：返回新的函数

// TODO: 实现 FilterExtension


/// 4. 实现一个泛型类 QueryBuilder<T>
///    - List<T> _data 存储数据
///    - List<StudentFilter> _filters 存储过滤器列表
///    - QueryBuilder(this._data)
///    - QueryBuilder<T> where(StudentFilter filter) → 添加过滤条件
///    - QueryBuilder<T> orderBy(int Function(T, T) comparator) → 排序
///    - QueryBuilder<T> limit(int n) → 限制条数
///    - QueryBuilder<T> skip(int n) → 跳过前 n 条
///    - List<T> get results → 执行查询并返回结果
///    - int get count → 结果条数
///
///    进阶：用 NoSuchMethod 支持动态字段查询
///    - 如果调用 queryBuilder.nameContains('小')，
///      动态生成 name 包含 '小' 的过滤器

// TODO: 实现 QueryBuilder 类


/// 5. 实现一个函数 List<Student> query(List<Student> data, QueryBuilder Function(QueryBuilder) builder)
///    方便快速构建查询

// TODO: 实现 query 函数


// ========== 测试代码（请勿修改）==========

void main() {
  print('========== 学生成绩系统 — 查询构建器 ==========\n');

  // ---- 准备数据 ----
  final students = [
    Student('小明', 92, 18, '高三'),
    Student('小红', 85, 17, '高二'),
    Student('小刚', 58, 16, '高一'),
    Student('小李', 73, 18, '高三'),
    Student('小文', 66, 17, '高二'),
    Student('小强', 95, 19, '高三'),
    Student('小芳', 47, 16, '高一'),
    Student('小军', 88, 18, '高三'),
    Student('小丽', 79, 17, '高二'),
    Student('小华', 61, 16, '高一'),
  ];
  print('--- 学生数据 (共${students.length}人) ---');
  for (final s in students) {
    print('  $s');
  }

  // ---- 测试1：基础过滤 ----
  print('\n--- 测试1：基础过滤 ---');
  final q1 = QueryBuilder<Student>(students)
      .where(ScoreFilter(60, 100))
      .results;
  print('  及格人数: ${q1.length}');

  // ---- 测试2：链式过滤 ----
  print('\n--- 测试2：链式过滤 ---');
  final q2 = QueryBuilder<Student>(students)
      .where(GradeFilter('高三'))
      .where(ScoreFilter(80, 100))
      .results;
  print('  高三成绩>=80: ${q2.length}人');
  for (final s in q2) {
    print('    $s');
  }

  // ---- 测试3：组合过滤器（运算符重载） ----
  print('\n--- 测试3：组合过滤器 ---');
  final filter1 = ScoreFilter(90, 100);  // 优秀
  final filter2 = GradeFilter('高一');    // 高一
  final combined = filter1 | filter2;     // 优秀 或 高一
  final q3 = QueryBuilder<Student>(students)
      .where(combined)
      .results;
  print('  优秀生或高一学生: ${q3.length}人');
  for (final s in q3) {
    print('    $s');
  }

  // ---- 测试4：排序 + 分页 ----
  print('\n--- 测试4：排序 + 分页 ---');
  final q4 = QueryBuilder<Student>(students)
      .where(ScoreFilter(60, 100))
      .orderBy((a, b) => b.score.compareTo(a.score)) // 按分数降序
      .skip(0)
      .limit(3)
      .results;
  print('  及格的前3名:');
  for (final s in q4) {
    print('    $s');
  }

  // ---- 测试5：运算符组合复杂查询 ----
  print('\n--- 测试5：复杂组合查询 ---');
  // (高三 且 分数>=80) 或 (名字包含"小芳")
  final complexFilter = (GradeFilter('高三') & ScoreFilter(80, 100)) |
      NameFilter('小芳');
  final q5 = QueryBuilder<Student>(students)
      .where(complexFilter)
      .results;
  print('  高三优等生或小芳: ${q5.length}人');
  for (final s in q5) {
    print('    $s');
  }

  // ---- 测试6：not 运算符 ----
  print('\n--- 测试6：not 运算符 ---');
  final notFailed = !ScoreFilter(0, 59); // 不是不及格的 = 及格的
  final q6 = QueryBuilder<Student>(students)
      .where(notFailed)
      .results;
  print('  非不及格: ${q6.length}人（应等于及格人数）');

  // ---- 测试7：query 辅助函数 ----
  print('\n--- 测试7：query 辅助函数 ---');
  final q7 = query(students, (qb) => qb
      .where(GradeFilter('高二'))
      .orderBy((a, b) => b.score.compareTo(a.score)));
  print('  高二学生(按分数降序):');
  for (final s in q7) {
    print('    $s');
  }

  // ---- 测试8：count ----
  print('\n--- 测试8：count ---');
  final qb = QueryBuilder<Student>(students)
      .where(ScoreFilter(90, 100));
  print('  优秀学生数: ${qb.count}');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 学生成绩系统 — 查询构建器 ==========
  //
  // --- 学生数据 (共10人) ---
  //   小明(92分, 18岁, 高三)
  //   小红(85分, 17岁, 高二)
  //   ...
  //
  // --- 测试1：基础过滤 ---
  //   及格人数: 8
  //
  // --- 测试2：链式过滤 ---
  //   高三成绩>=80: 3人
  //     ...
  //
  // --- 测试3：组合过滤器 ---
  //   优秀生或高一学生: 5人
  //     ...
  //
  // --- 测试4：排序 + 分页 ---
  //   及格的前3名:
  //     小强(95分, ...)
  //     小明(92分, ...)
  //     小军(88分, ...)
  //
  // --- 测试5：复杂组合查询 ---
  //   高三优等生或小芳: ...
  //
  // --- 测试6：not 运算符 ---
  //   非不及格: 8人
  //
  // --- 测试7：query 辅助函数 ---
  //   高二学生(按分数降序):
  //     ...
  //
  // --- 测试8：count ---
  //   优秀学生数: 2
  //
  // ========== 测试完成 ==========
}

// ====== 辅助扩展（QueryBuilder 的便利构造）=====

/// 给 List<Student> 加扩展方法 .query
extension StudentListQuery on List<Student> {
  List<Student> queryWhere(StudentFilter filter) {
    return QueryBuilder<Student>(this).where(filter).results;
  }
}
