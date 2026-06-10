// Dart 第六十七课：Stream 进阶 — 转换、过滤、广播

import 'dart:async';

void main() async {
  print('========== Stream 进阶 ==========');

  // ========== 1. map — 转换每个数据 ==========
  print('\n--- 1. map：数据转换 ---');

  var stream1 = Stream.fromIterable([1, 2, 3, 4, 5]);
  var mapped = stream1.map((n) => '数字: $n');

  await for (var s in mapped) {
    print('  $s');
  }

  // ========== 2. where — 过滤数据 ==========
  print('\n--- 2. where：条件过滤 ---');

  var stream2 = Stream.fromIterable([1, 2, 3, 4, 5, 6]);
  var even = stream2.where((n) => n.isEven);

  await for (var n in even) {
    print('  偶数: $n');  // 2, 4, 6
  }

  // ========== 3. distinct — 去重 ==========
  print('\n--- 3. distinct：连续去重 ---');

  var stream3 = Stream.fromIterable([1, 1, 2, 2, 2, 3, 1, 1]);
  var distinct = stream3.distinct();

  await for (var n in distinct) {
    print('  去重后: $n');  // 1, 2, 3, 1（只去掉连续的重复）
  }

  // ========== 4. take / skip — 取前N个 / 跳过N个 ==========
  print('\n--- 4. take / skip ---');

  var stream4 = Stream.fromIterable([1, 2, 3, 4, 5]);

  // 只取前 3 个
  await for (var n in stream4.take(3)) {
    print('  take(3): $n');  // 1, 2, 3
  }

  var stream5 = Stream.fromIterable([1, 2, 3, 4, 5]);
  // 跳过前 2 个
  await for (var n in stream5.skip(2)) {
    print('  skip(2): $n');  // 3, 4, 5
  }

  // ========== 5. timeout — 流超时 ==========
  print('\n--- 5. timeout：流超时 ---');

  var stream6 = Stream.periodic(const Duration(seconds: 2), (i) => i);

  try {
    await for (var n in stream6.timeout(const Duration(seconds: 1))) {
      print('  收到: $n');
    }
  } catch (e) {
    print('  超时了: $e');
  }

  // ========== 6. transform — 自定义转换器 ==========
  print('\n--- 6. transform：自定义转换器 ---');
  // 用 StreamTransformer 把数据按行拆分

  var lines = Stream.fromIterable(['Hello Dart', '你好 Dart']);
  var transformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      // 把一行按空格拆成多个单词
      for (var word in data.split(' ')) {
        sink.add('  -> $word');
      }
    },
  );

  var transformed = lines.transform(transformer);
  await for (var word in transformed) {
    print(word);
  }

  // ========== 7. broadcast — 广播流（多次监听） ==========
  print('\n--- 7. broadcast：广播流 ---');

  // 普通 Stream 只能监听一次
  var singleStream = Stream.fromIterable([1, 2, 3]);
  // singleStream.listen(print);  // ✅ 第一次
  // singleStream.listen(print);  // ❌ 报错！不能重复监听

  // 广播流可以监听多次
  var broadcastStream = Stream.fromIterable([10, 20, 30]).asBroadcastStream();

  broadcastStream.listen((data) => print('  监听者1: $data'));
  broadcastStream.listen((data) => print('  监听者2: $data'));

  // 等广播流执行完
  await Future.delayed(const Duration(milliseconds: 100));

  // ========== 8. Stream.fromFuture — 单个 Future 转流 ==========
  print('\n--- 8. Stream.fromFuture ---');

  var futureStream = Stream.fromFuture(Future.value('Future 转 Stream'));
  await for (var v in futureStream) {
    print('  $v');
  }

  // ========== 9. Stream.periodic — 周期性产生数据 ==========
  print('\n--- 9. Stream.periodic：周期流 ---');
  // 每隔一段时间产生一个数据

  var counter = 0;
  var periodic = Stream.periodic(
    const Duration(milliseconds: 300),
    (i) => '第 ${i + 1} 次',
  );

  await for (var msg in periodic.take(3)) {
    // take(3) 只取前3个，不然无限跑下去
    print('  $msg');
  }

  // ========== 10. 实用：debounce（防抖） ==========
  print('\n--- 10. 实用：debounce 防抖 ---');
  // 高频事件中，等停止触发后才执行最后一次

  Stream<int> fastEvents() {
    // 模拟快速触发的连续事件（比如输入框打字）
    return Stream.periodic(const Duration(milliseconds: 100), (i) => i)
        .take(10);
  }

  // 手动实现防抖：等 300ms 没有新数据再输出
  Stream<T> debounce<T>(Stream<T> source, Duration duration) {
    return source.transform(StreamTransformer<T, T>.fromHandlers(
      handleData: (data, sink) {
        // 这个简化实现只演示思路
        sink.add(data);
      },
    ));
  }

  // 用 throttle 控制频率（每 500ms 取最新的一个）
  Stream<T> throttle<T>(Stream<T> source, Duration duration) {
    var controller = StreamController<T>();
    var lastEvent = DateTime.now().subtract(duration);

    source.listen(
      (data) {
        var now = DateTime.now();
        if (now.difference(lastEvent) >= duration) {
          controller.add(data);
          lastEvent = now;
        }
      },
      onDone: () => controller.close(),
    );

    return controller.stream;
  }

  print('  原始流（每100ms一个）：');
  await for (var n in fastEvents()) {
    print('    $n');
  }

  print('  throttle（每500ms取一个）：');
  var throttled = throttle(fastEvents(), const Duration(milliseconds: 500));
  await for (var n in throttled) {
    print('    $n');
  }

  print('\n程序结束');
}

/*
总结：Stream 进阶操作

1. map        — 每个数据转换（String → int 等）
2. where      — 过滤（只保留符合条件的）
3. distinct   — 去重（去掉连续重复的）
4. take/skip  — 取前N个 / 跳过前N个
5. timeout    — 流超时（太长时间没数据就报错）
6. transform  — 自定义转换器（StreamTransformer）
7. broadcast  — 广播流（允许多个监听者）
8. fromFuture — 单个 Future 转 Stream
9. periodic   — 周期性产生数据
10. throttle  — 限流控制频率

对比：Stream vs Iterable 的方法

| 方法 | Stream | Iterable (List/Set) |
|------|--------|-------------------|
| map | ✅ | ✅ |
| where | ✅ | ✅ |
| distinct | ✅ | ❌ |
| take/skip | ✅ | ✅ |
| timeout | ✅ | ❌ |
| transform | ✅ | ❌ |

注意：
- 普通 Stream 只能监听一次，广播流（.asBroadcastStream()）多次
- Stream.periodic 是无限的，记得用 take 限制次数
- 防抖（debounce）适合输入框，节流（throttle）适合滚动事件
- transform 可以组合多个操作（map + where + ...）
*/
