// Dart 第六十课：dart:collection 集合类型深入

import 'dart:collection';

void main() {
  print('========== dart:collection ==========');

  // ========== 1. Queue 队列 ==========
  print('\n--- 1. Queue 先进先出 ---');
  var queue = Queue<String>();

  // 排队
  queue.addLast('小明');
  queue.addLast('小红');
  queue.addLast('小刚');
  print('排队顺序: ${queue.toList()}');

  // 处理
  while (queue.isNotEmpty) {
    var person = queue.removeFirst();
    print('  处理: $person');
  }

  // 也可以当栈用（后进先出）
  var stack = Queue<String>();
  stack.addLast('第一层');
  stack.addLast('第二层');
  stack.addLast('第三层');
  print('\n栈（后进先出）:');
  while (stack.isNotEmpty) {
    print('  弹出: ${stack.removeLast()}');
  }

  // ========== 2. HashMap vs LinkedHashMap vs SplayTreeMap ==========
  print('\n--- 2. Map 三种实现对比 ---');

  var hash   = HashMap<int, String>();    // 无序
  var linked = LinkedHashMap<int, String>(); // 插入顺序
  var tree   = SplayTreeMap<int, String>();  // 键排序

  var data = {3: '丙', 1: '甲', 4: '丁', 2: '乙'};

  data.forEach((k, v) {
    hash[k] = v;
    linked[k] = v;
    tree[k] = v;
  });

  print('HashMap(无序):     ${hash.keys}');
  print('LinkedHashMap(插入顺序): ${linked.keys}');
  print('SplayTreeMap(键排序):  ${tree.keys}');

  // ========== 3. HashSet vs LinkedHashSet vs SplayTreeSet ==========
  print('\n--- 3. Set 三种实现对比 ---');

  var hSet = HashSet<int>();
  var lSet = LinkedHashSet<int>();
  var tSet = SplayTreeSet<int>();

  var nums = [3, 1, 4, 1, 5, 2, 6];

  for (var n in nums) {
    hSet.add(n);
    lSet.add(n);
    tSet.add(n);
  }

  print('HashSet(无序):     $hSet');
  print('LinkedHashSet(插入顺序): $lSet');
  print('SplayTreeSet(排序):  $tSet');

  // ========== 4. UnmodifiableListView ==========
  print('\n--- 4. UnmodifiableListView ---');
  var original = [1, 2, 3];
  var readonly = UnmodifiableListView(original);

  print('原始: $original');
  print('只读视图: $readonly');

  // readonly[0] = 99;  // ❌ 运行时报错
  original[0] = 99;      // ✅ 原始列表还能改
  print('修改原始后只读视图也变了: $readonly');

  // 不可变的 Map 和 Set
  var um = UnmodifiableMapView({'a': 1, 'b': 2});
  // um['c'] = 3;  // ❌ 运行时报错

  var us = UnmodifiableSetView({1, 2, 3});
  // us.add(4);  // ❌ 运行时报错

  // ========== 5. 实际场景：排队叫号 ==========
  print('\n--- 5. 排队叫号 ---');
  var queue2 = Queue<String>();
  int nextNumber = 1;

  // 取号
  void takeNumber(String name) {
    var number = nextNumber++;
    queue2.addLast('$number号($name)');
    print('  $name 取了$number号');
  }

  // 叫号
  void callNext() {
    if (queue2.isNotEmpty) {
      print('  叫号: ${queue2.removeFirst()}');
    } else {
      print('  没有等待的客户');
    }
  }

  takeNumber('小明');
  takeNumber('小红');
  takeNumber('小刚');
  print('等待人数: ${queue2.length}');
  callNext();
  callNext();
  callNext();
  callNext();

  // ========== 6. 实际场景：LRU 缓存（LinkedHashMap） ==========
  print('\n--- 6. LinkedHashMap 实现 LRU ---');
  var cache = LinkedHashMap<String, String>();

  void setCache(String key, String value) {
    if (cache.containsKey(key)) {
      cache.remove(key);  // 删掉旧的
    }
    cache[key] = value;   // 重新插入到末尾
  }

  setCache('a', '数据A');
  setCache('b', '数据B');
  setCache('c', '数据C');
  print('初始: ${cache.keys}');

  // 访问 a，a 应该移到末尾
  setCache('a', '数据A');
  print('访问a后: ${cache.keys}');

  // 新增 d，淘汰最久未用的
  setCache('d', '数据D');
  print('新增d后: ${cache.keys}');

  // ========== 7. 实际场景：有序排行榜 ==========
  print('\n--- 7. SplayTreeMap 排行榜 ---');
  var rankings = SplayTreeMap<int, String>((a, b) => b.compareTo(a)); // 降序

  rankings[85] = '小明';
  rankings[92] = '小红';
  rankings[78] = '小刚';
  rankings[95] = '小丽';

  print('排行榜:');
  int rank = 1;
  for (var entry in rankings.entries) {
    print('  第${rank}名: ${entry.value} (${entry.key}分)');
    rank++;
  }

  print('\n程序结束');
}

/*
总结：dart:collection

1. Queue — 队列（先进先出）
   addLast / removeFirst → 排队
   addLast / removeLast → 栈

2. Map 三种实现
   HashMap          → 无序，最快
   LinkedHashMap    → 插入顺序（默认 Map 就是它）
   SplayTreeMap     → 键排序（需 Comparable）

3. Set 三种实现
   HashSet          → 无序，最快
   LinkedHashSet    → 插入顺序（默认 Set 就是它）
   SplayTreeSet     → 排序

4. 不可变视图
   UnmodifiableListView
   UnmodifiableMapView
   UnmodifiableSetView
   运行时保护，不抛编译错误

5. 适用场景
   Queue       → 排队、任务调度
   LinkedHashMap → LRU 缓存、保持插入顺序
   SplayTreeMap  → 排行榜、需要排序的 Map
*/
