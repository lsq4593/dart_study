// Dart 第四十四课：for-in 循环与 Iterable 迭代器

void main() {
  // ========== 1. for-in 基础 ==========
  // for-in 是遍历集合最简洁的方式
  var fruits = ['苹果', '香蕉', '西瓜'];

  for (var fruit in fruits) {
    print(fruit);
  }
  // 苹果
  // 香蕉
  // 西瓜

  // 等价于传统 for 循环：
  for (int i = 0; i < fruits.length; i++) {
    print(fruits[i]);
  }

  // ========== 2. for-in 遍历 Map ==========
  var scores = {'数学': 95, '英语': 87, '语文': 92};

  // entries → Map 自带属性，把每个键值对拆成一个 MapEntry 对象
  //           每个 entry 有 .key（键）和 .value（值）
  for (var entry in scores.entries) {
    // entry 的类型是 MapEntry<String, int>
    print('${entry.key}: ${entry.value}'); // 数学: 95
  }

  // keys → 只取所有键，返回 Iterable<String>
  for (var key in scores.keys) {
    print(key); // 数学、英语、语文
  }

  // values → 只取所有值，返回 Iterable<int>
  for (var value in scores.values) {
    print(value); // 95、87、92
  }

  // ========== 3. Iterable 是什么？ ==========
  // Iterable = "可以一个一个取出来" 的东西，是所有集合的父类型
  // List、Set、Map 的 keys/values/entries 都是 Iterable

  Iterable<int> numbers = [1, 2, 3, 4, 5]; // List 就是 Iterable
  Set<String> names = {'小明', '小红'}; // Set 也是 Iterable

  // for-in 背后其实就是调用 iterator（迭代器）
  // iterator 有两个关键东西：
  //   - moveNext() → 往前走一步，返回 true（还有）或 false（没了）
  //   - current   → 当前指向的元素
  var iterator = numbers.iterator;
  while (iterator.moveNext()) {
    // moveNext() 先走一步，然后 current 拿到当前位置的值
    print(iterator.current); // 1, 2, 3, 4, 5
  }
  // 等价于：for (var n in numbers) { print(n); }

  // ========== 4. Iterable 的常用方法 ==========
  var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // map — 转换每个元素，返回 Iterable（惰性，不立刻执行）
  //        参数是一个函数，接收当前元素 n，返回转换后的值
  var doubled = nums.map((n) => n * 2); // 每个元素乘以2
  // 直接 print 是小括号，因为 doubled 是 Iterable 类型
  print(doubled);        // (2, 4, 6, 8, 10, 12, 14, 16, 18, 20)
  // toList() 把 Iterable 转成 List，打印就是方括号
  print(doubled.toList()); // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]

  // where — 过滤元素，保留满足条件的（类似 JS 的 filter）
  //         参数是条件函数，返回 true 的保留
  var evens = nums.where((n) => n.isEven); // 只保留偶数
  print(evens.toList()); // [2, 4, 6, 8, 10]

  // firstWhere — 找第一个满足条件的元素，直接返回值（不是 Iterable）
  var firstBig = nums.firstWhere((n) => n > 5); // 第一个大于5的
  print(firstBig); // 6

  // take(n) — 只取前 n 个元素（惰性）
  var top3 = nums.take(3); // 取前3个
  print(top3.toList()); // [1, 2, 3]

  // skip(n) — 跳过前 n 个元素，取剩下的（惰性）
  var after5 = nums.skip(5); // 跳过前5个
  print(after5.toList()); // [6, 7, 8, 9, 10]

  // takeWhile — 持续取元素，直到条件为 false 就停止（遇到不满足的立即停）
  var small = nums.takeWhile((n) => n < 4); // 小于4的都取，遇到4就停
  print(small.toList()); // [1, 2, 3]

  // skipWhile — 持续跳过元素，直到条件为 false 就开始取（遇到不满足的立即开始取）
  var from5 = nums.skipWhile((n) => n < 5); // 小于5的都跳过，遇到5就开始取
  print(from5.toList()); // [5, 6, 7, 8, 9, 10]

  // ========== 5. 链式调用 ==========
  // 因为 map/where/take 返回的都是 Iterable，所以可以一直链式拼接
  var result = nums
      .where((n) => n.isEven) // 第一步：过滤偶数 → [2, 4, 6, 8, 10]
      .map((n) => n * n)     // 第二步：每个平方   → [4, 16, 36, 64, 100]
      .take(3)                // 第三步：取前3个    → [4, 16, 36]
      .toList();              // 第四步：转为 List（触发执行）
  print(result); // [4, 16, 36]

  // ========== 6. reduce 和 fold ==========
  // reduce — 把所有元素合并成一个值，用第一个元素作为初始值
  //          acc = 累积结果，n = 当前元素
  //          acc + n  → 可以换成任何操作（加、乘、拼接等）
  var sum = nums.reduce((acc, n) => acc + n);
  // 过程：0+1=1, 1+2=3, 3+3=6, 6+4=10, ... 最终=55
  print(sum); // 55

  // fold — 和 reduce 类似，但可以自己指定初始值
  //   fold<返回类型>(初始值, (acc, n) => 操作)
  //   初始值给 0 → 累加，给 1 → 累乘，给 '' → 拼接字符串
  var product = nums.fold<int>(1, (acc, n) => acc * n);
  // 过程：1*1=1, 1*2=2, 2*3=6, 6*4=24, ... 最终=3628800
  print(product); // 3628800

  // fold 拼接字符串示例
  var words = ['你', '好', '吗'];
  var greeting = words.fold('', (acc, w) => acc + w);
  print(greeting); // 你好吗

  // ========== 7. any / every / contains ==========
  // any — 是否有任意一个元素满足条件（类似 JS 的 some）
  print(nums.any((n) => n > 8)); // true

  // every — 是否所有元素都满足条件（类似 JS 的 every）
  print(nums.every((n) => n > 0)); // true

  // contains — 是否包含某个值（不需要写函数，直接传值）
  print(nums.contains(5)); // true

  // ========== 8. 自定义 Iterable ==========
  // 自己写一个可迭代的斐波那契数列
  var fibonacci = Fibonacci(10); // 生成前10个
  for (var n in fibonacci) {
    print(n); // 1, 1, 2, 3, 5, 8, 13, 21, 34, 55
  }

  // ========== 9. Iterable 的惰性特性 ==========
  // 重点！map/where/take 不会立刻执行，只是"描述"操作步骤
  // 只有在真正需要数据时（遍历、toList、length 等）才逐个计算
  var lazy = nums.map((n) {
    print('计算: $n'); // ← 这行不会立刻打印！
    return n * 2;
  }); // ← 到这里什么都没发生，只是建了一条"管道"

  print('开始遍历...'); // 先打印这行
  lazy.take(3).toList(); // ← 现在才真正计算，而且只算了前3个！
  // 输出：
  // 开始遍历...
  // 计算: 1
  // 计算: 2
  // 计算: 3
  // 后面的 4~10 根本没算，省了计算和时间！
}

// ========== 自定义 Iterable 示例：斐波那契数列 ==========
// 要自定义 Iterable，需要两步：
//   1. 继承 Iterable，实现 get iterator → 返回一个迭代器
//   2. 写一个 Iterator，实现 moveNext() 和 current
class Fibonacci extends Iterable<int> {
  final int count; // 要生成多少个
  Fibonacci(this.count);

  @override
  Iterator<int> get iterator => _FibIterator(count); // 返回自定义迭代器
}

class _FibIterator implements Iterator<int> {
  int remaining; // 剩余要生成的个数
  int _prev = 0;    // 前一个数
  int _current = 1; // 当前数（斐波那契从 1, 1, 2, 3... 开始）

  _FibIterator(this.remaining);

  @override
  int get current => _current; // 返回当前值

  @override
  bool moveNext() {
    if (remaining <= 0) return false; // 没有剩余了，结束
    remaining--; // 消耗一个名额
    var next = _prev + _current; // 计算下一个 = 前一个 + 当前
    _prev = _current;             // 前一个变成当前
    _current = next;              // 当前变成新算出来的
    return true;                  // 告诉调用者：还有下一个
  }
}

/*
对比：for-in vs 传统 for

| | for-in | 传统 for (index) |
|---|---|---|
| 语法 | for (var item in list) | for (int i = 0; i < list.length; i++) |
| 可读性 | ✅ 简洁清晰 | ❌ 冗长 |
| 需要索引 | ❌ 拿不到 index | ✅ 有 i |
| 适用范围 | 任何 Iterable | 只有 List（有 length 的） |

对比：Iterable vs List

| | Iterable | List |
|---|---|---|
| 能否修改 | ❌ 只读 | ✅ add/remove |
| 按索引访问 | ❌ | ✅ list[0] |
| 是否惰性 | ✅ 可以（懒加载） | ❌ 立即计算 |
| 内存占用 | ✅ 按需，更省 | ❌ 全部加载 |
| 用途 | 数据处理管道 | 存储和修改数据 |

核心记忆：
- for-in 是遍历 Iterable 的语法糖
- Iterable 的 map/where/take 是惰性的，toList() 才真正执行
- 惰性 = 不用不计算，用多少算多少，省内存！
*/
