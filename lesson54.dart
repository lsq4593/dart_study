// Dart 第五十四课：sync* 同步生成器

Future<void> main() async {
  print('========== sync* 同步生成器 ==========');

  // ========== 1. 基本用法 ==========
  print('\n--- 1. 基本：sync* yield ---');
  for (var n in countTo(5)) {
    print(n);  // 1 2 3 4 5
  }

  // ========== 2. 惰性求值 ==========
  print('\n--- 2. 惰性求值（用到才生成） ---');
  var numbers = oneByOne();

  print('还没取值，什么都没发生');
  var it = numbers.iterator;

  print('取第1个:');
  it.moveNext();
  print('  值: ${it.current}');

  print('取第2个:');
  it.moveNext();
  print('  值: ${it.current}');

  print('取第3个:');
  it.moveNext();
  print('  值: ${it.current}');

  // ========== 3. 生成大量数据 ==========
  print('\n--- 3. 大量数据不占内存 ---');
  // 传统方式：先创建 List 再遍历
  var list = List.generate(1000000, (i) => i);  // 占内存
  print('List 方式: 已创建 1000000 个元素');

  // sync* 方式：随用随生成，不占内存
  Iterable<int> bigRange(int n) sync* {
    for (int i = 0; i < n; i++) {
      yield i;
    }
  }

  var range = bigRange(1000000);
  print('sync* 方式: 只占少量内存');

  // 取前 5 个
  print('前5个: ${range.take(5).toList()}');

  // ========== 4. yield* 委托另一个 Iterable ==========
  print('\n--- 4. yield* 委托 ---');
  print(combine().toList());

  // ========== 5. 递归生成器 ==========
  print('\n--- 5. 递归生成器 ---');
  print('斐波那契前10项: ${fibonacci(10).toList()}');

  // ========== 6. 实际场景：分页遍历 ==========
  print('\n--- 6. 模拟分页遍历 ---');
  var pages = paginate(100, 30);

  int pageCount = 0;
  for (var page in pages) {
    pageCount++;
    print('  第$pageCount页: 第${page.first}-${page.last}条');
  }
  print('共 $pageCount 页');

  // ========== 7. sync* 生成 Map 或 自定义对象 ==========
  print('\n--- 7. 生成枚举值信息 ---');
  for (var info in describeEnums()) {
    print('  ${info['name']}: code=${info['code']}');
  }

  // ========== 8. sync* vs async* 对比 ==========
  print('\n--- 8. sync* 与 async* 用法对比 ---');

  // sync* — 同步，立刻取到值
  print('sync* 结果:');
  var syncResult = syncRange(3);
  print('  syncRange(3) 已返回，还没取值');
  print('  值: ${syncResult.toList()}');

  // async* — 异步，需要 await
  await compareAsync();
}

// ========== 异步对比函数 ==========
Future<void> compareAsync() async {
  print('async* 结果:');
  var asyncResult = asyncRange(3);
  print('  asyncRange(3) 已返回，还没监听');
  await for (var n in asyncResult) {
    print('  收到: $n');
  }
}

// ========== 1. 基本 sync* ==========
Iterable<int> countTo(int n) sync* {
  for (int i = 1; i <= n; i++) {
    yield i;
  }
}

// ========== 2. 演示惰性求值 ==========
Iterable<int> oneByOne() sync* {
  print('  生成 1');
  yield 1;
  print('  生成 2');
  yield 2;
  print('  生成 3');
  yield 3;
}

// ========== 4. yield* 委托 ==========
Iterable<int> part1() sync* {
  yield 1;
  yield 2;
}

Iterable<int> part2() sync* {
  yield 3;
  yield 4;
}

Iterable<int> combine() sync* {
  yield* part1();  // 委托给 part1
  yield* part2();  // 委托给 part2
  yield 5;         // 再加一个
}

// ========== 5. 斐波那契 ==========
Iterable<int> fibonacci(int n) sync* {
  int a = 0, b = 1;
  for (int i = 0; i < n; i++) {
    yield a;
    int temp = a + b;
    a = b;
    b = temp;
  }
}

// ========== 6. 分页遍历 ==========
Iterable<List<int>> paginate(int total, int pageSize) sync* {
  int start = 0;
  while (start < total) {
    int end = start + pageSize;
    if (end > total) end = total;
    yield List.generate(end - start, (i) => start + i + 1);
    start = end;
  }
}

// ========== 7. 生成 Map ==========
Iterable<Map<String, dynamic>> describeEnums() sync* {
  yield {'name': 'success', 'code': 200};
  yield {'name': 'notFound', 'code': 404};
  yield {'name': 'error', 'code': 500};
}

// ========== 8. sync* 对比 ==========
Iterable<int> syncRange(int n) sync* {
  for (int i = 1; i <= n; i++) {
    yield i;
  }
}

Stream<int> asyncRange(int n) async* {
  for (int i = 1; i <= n; i++) {
    await Future.delayed(Duration(milliseconds: 1));
    yield i;
  }
}

/*
总结：sync* 生成器

1. 语法
   Iterable<T> 函数名() sync* {
     yield 值1;
     yield 值2;
   }

2. 核心特点：惰性求值
   - 用到才生成，不用不生成
   - 适合大量数据（几百万个也不占内存）
   - 取多少个就生成多少个，不浪费

3. yield* 委托
   把一个 Iterable 的数据"展开"到当前生成器中

4. sync* vs async*
   sync*  → Iterable<T>  → 同步，无 await
   async* → Stream<T>    → 异步，可 await

5. 和 List 对比
   List.generate(n, fn)  — 一次性生成所有，占内存
   sync*                  — 惰性生成，不占内存
*/
