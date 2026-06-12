// Dart 练习题 — 第21题：数据流水线处理器
// 知识点：泛型、Stream、sync*、Iterable 链式调用、extension、Record

/// 实现一个泛型数据流水线，支持链式处理数据流。
/// 完成下方 TODO 区域，使 main 函数能正确运行。

// ========== TODO 区域 ==========

/// 1. 实现一个泛型类 Pipeline<T>，支持链式调用：
///    - Pipeline(this.data) 构造函数，接收 List<T>
///    - List<T> get data 返回当前数据
///    - Pipeline<T> where(bool Function(T) test) 过滤元素
///    - Pipeline<R> map<R>(R Function(T) transform) 转换元素
///    - T reduce(T Function(T, T) combine) 归约
///    - void forEach(void Function(T) action) 遍历
///    - int get count 返回元素个数
///    - List<T> toList() 转回 List

// TODO: 定义 Pipeline<T> 类



/// 2. 给 List<T> 加扩展方法 .pipeline，返回 Pipeline<T>
// TODO: 定义 ListExtension<T> 扩展



/// 3. 实现一个 sync* 生成器 Iterable<int> range(int start, int end)
///    生成从 start 到 end（包含）的整数序列

// TODO: 实现 range 函数



/// 4. 实现一个函数 (int start, int end) => ({int sum, int count, double avg})
///    用 range + Pipeline 计算总和、个数、平均值，返回 Record

// TODO: 实现 stats 函数



// ========== 测试代码（请勿修改）==========

void main() {
  print('========== 数据流水线处理器 ==========\n');

  // ---- 测试1：基础 Pipeline ----
  print('--- 测试1：Pipeline 基础 ---');
  final nums = Pipeline<int>([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  print('原始数据: ${nums.data}');
  print('个数: ${nums.count}');

  // ---- 测试2：链式调用 ----
  print('\n--- 测试2：链式调用 ---');
  final result = nums
      .where((n) => n % 2 == 0)    // 过滤偶数
      .map((n) => '第${n}号');      // 转字符串
  print('偶数: ${result.data}');

  // ---- 测试3：reduce ----
  print('\n--- 测试3：reduce ---');
  final sum = nums
      .where((n) => n > 5)
      .reduce((a, b) => a + b);
  print('大于5的数之和: $sum');

  // ---- 测试4：extension .pipeline ----
  print('\n--- 测试4：extension ---');
  final words = ['apple', 'banana', 'cat', 'dragon', 'elephant', 'fish']
      .pipeline
      .where((w) => w.length >= 4)
      .map((w) => w.toUpperCase())
      .toList();
  print('长度>=4的大写: $words');

  // ---- 测试5：range 生成器 ----
  print('\n--- 测试5：range ---');
  final evens = range(1, 20)
      .where((n) => n % 2 == 0)
      .toList();
  print('1~20的偶数: $evens');

  // ---- 测试6：stats 函数 ----
  print('\n--- 测试6：stats ---');
  final s = stats(1, 100);
  print('1~100之和: ${s.sum}');
  print('1~100个数: ${s.count}');
  print('1~100平均值: ${s.avg}');

  // ---- 测试7：空数据处理 ----
  print('\n--- 测试7：空数据 ---');
  final empty = Pipeline<int>([])
      .where((n) => n > 0)
      .map((n) => n * 2);
  print('空数据个数: ${empty.count}');
  print('空数据列表: ${empty.toList()}');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 数据流水线处理器 ==========
  //
  // --- 测试1：Pipeline 基础 ---
  // 原始数据: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  // 个数: 10
  //
  // --- 测试2：链式调用 ---
  // 偶数: [第2号, 第4号, 第6号, 第8号, 第10号]
  //
  // --- 测试3：reduce ---
  // 大于5的数之和: 40
  //
  // --- 测试4：extension ---
  // 长度>=4的大写: [APPLE, BANANA, DRAGON, ELEPHANT]
  //
  // --- 测试5：range ---
  // 1~20的偶数: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
  //
  // --- 测试6：stats ---
  // 1~100之和: 5050
  // 1~100个数: 100
  // 1~100平均值: 50.5
  //
  // --- 测试7：空数据 ---
  // 空数据个数: 0
  // 空数据列表: []
  //
  // ========== 测试完成 ==========
}
