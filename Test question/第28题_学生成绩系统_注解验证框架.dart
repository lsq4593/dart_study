// Dart 练习题 — 第28题：学生成绩系统 — 注解验证框架
// 知识点：注解、反射、泛型约束、自定义异常、extension type
//
// 用注解实现一个通用的数据验证框架，对学生成绩数据进行校验。
// 完成下方 TODO 区域，使 main 函数能正确运行。

// ========== TODO 区域 ==========

/// 1. 自定义异常类
///    - ValidationException(String message, String field)
///    - ValidationResult: 包含 bool isValid, List<ValidationException> errors
///      加 String get message → 格式化的错误信息

// TODO: 定义 ValidationException 和 ValidationResult


/// 2. 定义验证注解（所有注解类构造函数必须是 const）
///    - @Range({int min = 0, int max = 100}) — 数值范围校验
///    - @NotEmpty({String message = "不能为空"}) — 字符串非空校验
///    - @Positive({String message = "必须为正数"}) — 正数校验
///    - @Length({int min = 1, int max = 20}) — 字符串长度校验

// TODO: 定义 Range、NotEmpty、Positive、Length 注解类


/// 3. 定义一个泛型抽象类 Validator<T>
///    - ValidationResult validate(T value)
///    - 用反射读取 T 类型上的注解
///    - 遍历 T 的所有字段，检查字段上的注解
///    - 所有字段都通过则返回 isValid=true
///    - 提示：用 dynamic 类型读取实例的字段
///    - 提示：可能需要 import 'dart:reflectable' 或手动处理
///
///    简化方案（不依赖 mirrors）：
///    Validator 不直接用反射，而是由子类实现 validate 方法。
///    但题目目标是展示注解定义与使用，以及泛型约束。
///
///    实现一个简化版：
///    - class FieldValidator<T> 对单个字段做校验
///    - 定义函数 validateField<T>(T value, List<Object> annotations)
///      根据注解列表做校验

// TODO: 实现验证逻辑


/// 4. 定义一个类 Student（用注解标记字段）
///    - @NotEmpty() String name
///    - @Range(min: 0, max: 100) int score
///    - @Positive() int age
///    - @Length(min: 2, max: 10) String? grade
///    - 构造函数、toString

// TODO: 定义 Student 类


/// 5. 实现函数 ValidationResult validateStudent(Student student)
///    手动校验 Student 各字段的注解约束
///    （简化实现：直接在函数里写校验逻辑，但使用定义的注解类）
///
///    进阶目标：用反射自动读取注解并校验
///    由于 dart:mirrors 在 CLI 可用，提供一个使用 mirrors 的版本：

// TODO: 实现 validateStudent 函数


/// 6. 实现一个泛型函数 T? parseFromMap<T>(
///        Map<String, dynamic> map, T Function(Map<String, dynamic>) fromJson)
///    从 Map 安全解析，如果解析失败返回 null
///    提示：用 try-catch 包裹

// TODO: 实现 parseFromMap 函数


// ========== 测试代码（请勿修改）==========

// 注意：dart:mirrors 在 Dart CLI 中可用
// 运行：dart run "Test question/第28题_学生成绩系统_注解验证框架.dart"
// 如果 mirrors 不可用，程序应给出友好提示

void main() {
  print('========== 学生成绩系统 — 注解验证框架 ==========\n');

  // ---- 测试1：注解定义 ----
  print('--- 测试1：注解定义 ---');
  const range = Range(min: 0, max: 100);
  const notEmpty = NotEmpty();
  const positive = Positive();
  const length = Length(min: 2, max: 10);
  print('  Range(0~100): ${range.min}~${range.max} ✅');
  print('  NotEmpty: ${notEmpty.message} ✅');
  print('  Positive: ${positive.message} ✅');
  print('  Length(2~10): ${length.min}~${length.max} ✅');

  // ---- 测试2：Student 创建 ----
  print('\n--- 测试2：Student 创建 ---');
  final validStudent = Student('小明', 85, 18, '高三');
  print('  合法学生: ${validStudent} ✅');

  final invalidStudent = Student('', -5, -1, null);
  print('  非法学生: ${invalidStudent} ❌');

  // ---- 测试3：手动校验合法数据 ----
  print('\n--- 测试3：手动校验合法数据 ---');
  final result1 = validateStudent(validStudent);
  print('  校验结果: ${result1.isValid ? "通过 ✅" : "失败 ❌"}');
  if (!result1.isValid) {
    for (final e in result1.errors) {
      print('    [${e.field}] ${e.message}');
    }
  }

  // ---- 测试4：手动校验非法数据 ----
  print('\n--- 测试4：手动校验非法数据 ---');
  final result2 = validateStudent(invalidStudent);
  print('  校验结果: ${result2.isValid ? "通过 ✅" : "失败 ❌"}');
  if (!result2.isValid) {
    for (final e in result2.errors) {
      print('    [${e.field}] ${e.message}');
    }
  }

  // ---- 测试5：边界值校验 ----
  print('\n--- 测试5：边界值校验 ---');
  final borderCases = [
    Student('', 0, 0, ''),
    Student('a', 100, 1, '一年级'),
    Student('张三', -1, 25, null),
    Student('李四', 101, 30, '高中三年级'),
  ];
  for (final s in borderCases) {
    final r = validateStudent(s);
    print('  ${s.name}(${s.score}分): ${r.isValid ? "✅" : "❌"} ${r.message}');
  }

  // ---- 测试6：parseFromMap ----
  print('\n--- 测试6：parseFromMap ---');
  final validMap = {'name': '小红', 'score': 92, 'age': 17, 'grade': '高二'};
  final parsed = parseFromMap(validMap, Student.fromJson);
  print('  解析成功: ${parsed != null}');
  if (parsed != null) {
    final vr = validateStudent(parsed);
    print('  校验结果: ${vr.isValid ? "通过 ✅" : "失败 ❌"}');
  }

  final badMap = {'name': 123, 'score': 'abc', 'age': null};
  final failed = parseFromMap(badMap, Student.fromJson);
  print('  错误数据解析: ${failed == null ? "返回 null ✅" : "非 null ❌"}');

  // ---- 测试7：批量校验 ----
  print('\n--- 测试7：批量校验 ---');
  final classData = [
    Student('小明', 92, 18, '高三'),
    Student('小刚', 58, 17, '高二'),
    Student('', 85, -1, null),
    Student('小红', 100, 16, ''),
    Student('小文', 73, 19, '高三'),
  ];
  int passed = 0, failedCount = 0;
  for (final s in classData) {
    final r = validateStudent(s);
    if (r.isValid) {
      passed++;
      print('  ✅ ${s.name} 通过');
    } else {
      failedCount++;
      print('  ❌ ${s.name} 失败: ${r.message}');
    }
  }
  print('  全班 ${classData.length} 人: 通过 $passed 人, 未通过 $failedCount 人');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 学生成绩系统 — 注解验证框架 ==========
  //
  // --- 测试1：注解定义 ---
  //   Range(0~100): 0~100 ✅
  //   NotEmpty: 不能为空 ✅
  //   Positive: 必须为正数 ✅
  //   Length(2~10): 2~10 ✅
  //
  // --- 测试2：Student 创建 ---
  //   合法学生: 小明(85分, 18岁) ✅
  //   非法学生: (-5分, -1岁) ❌
  //
  // --- 测试3：手动校验合法数据 ---
  //   校验结果: 通过 ✅
  //
  // --- 测试4：手动校验非法数据 ---
  //   校验结果: 失败 ❌
  //     [name] 不能为空
  //     [score] 分数必须在 0~100 之间
  //     [age] 必须为正数
  //
  // --- 测试5：边界值校验 ---
  //   (0分): ❌ ...
  //   a(100分): ❌ name 长度不足
  //   张三(-1分): ❌ 必须为正数
  //   李四(101分): ❌ 分数必须在 0~100 之间
  //
  // --- 测试6：parseFromMap ---
  //   解析成功: true
  //   校验结果: 通过 ✅
  //   错误数据解析: 返回 null ✅
  //
  // --- 测试7：批量校验 ---
  //   ✅ 小明 通过
  //   ✅ 小刚 通过
  //   ❌  失败: ...
  //   ✅ 小红 通过
  //   ✅ 小文 通过
  //   全班 5 人: 通过 4 人, 未通过 1 人
  //
  // ========== 测试完成 ==========
}

// ====== 工具函数 ======

/// Student.fromJson 工厂构造函数
extension StudentFromJson on Student {
  static Student fromJson(Map<String, dynamic> json) {
    return Student(
      json['name'] as String? ?? '',
      (json['score'] as num?)?.toInt() ?? 0,
      (json['age'] as num?)?.toInt() ?? 0,
      json['grade'] as String?,
    );
  }
}
