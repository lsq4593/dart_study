// Dart 第四十五课：Set 集合

void main() {
  // ========== 1. Set 是什么？ ==========
  // Set = 无序、不重复的集合
  // List 有序可重复 [1, 1, 2]
  // Set  无序不重复 {1, 2}

  // 创建 Set
  var fruits = <String>{'苹果', '香蕉', '西瓜'};
  print(fruits); // {苹果, 香蕉, 西瓜}  ← 花括号，不是方括号

  // 也可以用 Set 构造函数
  var numbers = Set<int>.from([1, 2, 3, 3, 2, 1]);
  print(numbers); // {1, 2, 3}  ← 自动去重了！

  // ========== 2. 自动去重 ==========
  var list = [1, 1, 2, 2, 3, 3, 3];
  var unique = list.toSet(); // List → Set，去掉重复
  print(unique); // {1, 2, 3}
  print(unique.toList()); // [1, 2, 3]  ← 再转回 List

  // 常见场景：去掉字符串里的重复字符
  var chars = 'hello'.split('').toSet();
  print(chars); // {h, e, l, o}  ← 两个 l 只剩一个

  // ========== 3. 添加和删除 ==========
  var set1 = <int>{1, 2, 3};

  set1.add(4); // 添加元素
  print(set1); // {1, 2, 3, 4}

  set1.add(2); // 添加重复的 → 没变化，Set 会忽略
  print(set1); // {1, 2, 3, 4}

  set1.addAll([5, 6]); // 批量添加
  print(set1); // {1, 2, 3, 4, 5, 6}

  set1.remove(3); // 删除元素
  print(set1); // {1, 2, 4, 5, 6}

  // ========== 4. 查询 ==========
  var names = {'小明', '小红', '小刚'};

  print(names.contains('小明')); // true  — 是否包含某个元素
  print(names.contains('小李')); // false

  print(names.length); // 3  — 元素个数

  // ========== 5. 集合运算 ==========
  var a = {1, 2, 3, 4};
  var b = {3, 4, 5, 6};

  // 并集 — 合并两个集合的所有元素
  print(a.union(b)); // {1, 2, 3, 4, 5, 6}

  // 交集 — 两个集合都有的元素
  print(a.intersection(b)); // {3, 4}

  // 差集 — a 里有但 b 里没有的
  print(a.difference(b)); // {1, 2}

  // ========== 6. Set 也是 Iterable ==========
  // 所以 for-in、map、where 等方法都能用
  var scores = {85, 92, 78, 95, 60};

  for (var s in scores) {
    print(s); // 逐个遍历（顺序不确定！）
  }

  // 过滤
  var passed = scores.where((s) => s >= 60);
  print(passed.toList()); // [85, 92, 78, 95, 60]

  // ========== 7. Set 和 List 的区别 ==========
  var listA = [1, 2, 3, 2, 1];
  var setB = {1, 2, 3, 2, 1};

  print(listA); // [1, 2, 3, 2, 1]  ← 保留重复，有顺序
  print(setB); // {1, 2, 3}        ← 自动去重，无顺序

  // List 可以按索引访问
  print(listA[0]); // 1

  // Set 不能按索引访问（没有 []）
  // print(setB[0]); // ❌ 编译报错！

  // ========== 8. 实际应用场景 ==========

  // 场景1：给数组去重（最常用）
  var ids = [101, 102, 103, 102, 101, 104];
  var uniqueIds = ids.toSet().toList();
  print(uniqueIds); // [101, 102, 103, 104]

  // 场景2：检查两个用户是否有共同好友
  var myFriends = {'小明', '小红', '小刚', '小李'};
  var yourFriends = {'小红', '小刚', '小王', '小赵'};
  var common = myFriends.intersection(yourFriends);
  print('共同好友: $common'); // 共同好友: {小红, 小刚}

  // 场景3：标签系统（不能有重复标签）
  var tags = <String>{};
  tags.add('dart');
  tags.add('flutter');
  tags.add('dart'); // 重复添加无效
  print(tags); // {dart, flutter}

  // 场景4：快速判断是否存在（比 List 快）
  // Set 的 contains 是 O(1)，List 是 O(n)
  // 数据量大时差距明显
  var bigSet = List.generate(100000, (i) => i).toSet();
  var bigList = List.generate(100000, (i) => i);
  print(bigSet.contains(99999)); // 瞬间
  print(bigList.contains(99999)); // 要从头找到尾
}

/*
对比：Set vs List vs Map

| | List | Set | Map |
|---|---|---|---|
| 符号 | [1, 2, 3] | {1, 2, 3} | {'a': 1} |
| 有序 | ✅ 插入顺序 | ❌ 无序 | ✅ 插入顺序 |
| 可重复 | ✅ | ❌ 自动去重 | key 不重复 |
| 索引访问 | ✅ list[0] | ❌ | ❌ |
| contains 速度 | O(n) 慢 | O(1) 快 | O(1) 快 |
| 用途 | 有序数据 | 去重、快速查找 | 键值映射 |

Set 常用方法速查：
  .add(元素)           — 添加
  .addAll([列表])      — 批量添加
  .remove(元素)         — 删除
  .contains(元素)       — 是否包含（O(1) 快！）
  .union(其他Set)       — 并集
  .intersection(其他Set)— 交集
  .difference(其他Set)  — 差集

List 转 Set → list.toSet()
Set 转 List → set.toList()
*/
