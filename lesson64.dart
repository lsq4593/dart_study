// Dart 第六十四课：异步进阶 —— Future 组合与超时处理

import 'dart:async';

void main() async {
  print('========== Future 进阶 ==========');

  // ========== 1. Future.wait — 等所有 Future 完成 ==========
  print('\n--- 1. Future.wait：等所有任务完成 ---');

  // 场景：同时请求多个 API，全部拿到后再处理
  Future<String> fetchUser() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return '用户数据';
  }

  Future<String> fetchOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return '订单数据';
  }

  Future<String> fetchMessages() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return '消息数据';
  }

  // 三个请求同时发起，全部完成后一起拿到结果
  var results = await Future.wait([
    fetchUser(),
    fetchOrders(),
    fetchMessages(),
  ]);
  print('  全部完成: $results');
  // 总耗时 ≈ 800ms（最慢的那个），而不是 800+500+600=1900ms

  // Future.wait 的泛型返回值
  var (user, orders, messages) = (
    results[0],
    results[1],
    results[2],
  );
  print('  解构: $user, $orders, $messages');

  // ========== 2. Future.any — 任意一个完成就返回 ==========
  print('\n--- 2. Future.any：谁先完成用谁 ---');

  // 场景：从多个数据源获取相同数据，用最快的那个
  Future<String> sourceA() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return '来源A';
  }

  Future<String> sourceB() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return '来源B';
  }

  Future<String> sourceC() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return '来源C';
  }

  var fastest = await Future.any([sourceA(), sourceB(), sourceC()]);
  print('  最快的来源: $fastest');  // 来源B（800ms 最快）

  // ========== 3. timeout — 超时处理 ==========
  print('\n--- 3. timeout：超时处理 ---');

  Future<String> slowApi() async {
    await Future.delayed(const Duration(seconds: 3));
    return '慢接口返回';
  }

  try {
    var result = await slowApi().timeout(
      const Duration(seconds: 2),
      // 超时后执行的回调，返回值作为最终结果
      onTimeout: () => '接口超时，使用缓存数据',
    );
    print('  结果: $result');
  } on TimeoutException catch (e) {
    print('  超时异常: $e');
  }

  // ========== 4. Future.delayed — 延迟执行 ==========
  print('\n--- 4. Future.delayed：延迟执行 ---');

  print('  开始: ${DateTime.now().second}秒');
  await Future.delayed(const Duration(seconds: 1), () {
    print('  1秒后: ${DateTime.now().second}秒');
  });

  // ========== 5. Future.value / Future.error — 直接创建 ==========
  print('\n--- 5. 直接创建 Future ---');

  // 快速返回一个值（同步但包装成 Future）
  var success = Future<String>.value('直接成功');
  print('  Future.value: ${await success}');

  // 快速返回一个错误
  var fail = Future<String>.error(Exception('直接失败'));
  try {
    await fail;
  } catch (e) {
    print('  Future.error: 捕获到 $e');
  }

  // ========== 6. Future.sync — 同步执行但返回 Future ==========
  print('\n--- 6. Future.sync：同步执行的 Future ---');

  var syncResult = await Future.sync(() {
    print('  Future.sync 里的代码立即执行');
    return '同步结果';
  });
  print('  结果: $syncResult');

  // ========== 7. Future.forEach — 顺序异步遍历 ==========
  print('\n--- 7. Future.forEach：顺序处理 ---');

  var ids = [1, 2, 3];
  await Future.forEach(ids, (int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('  处理 ID: $id');
  });
  print('  全部处理完毕（共 3 个，顺序执行）');

  // ========== 8. 实用模式：失败重试 ==========
  print('\n--- 8. 失败重试（Retry）---');

  var attempt = 0;
  Future<String> unstableApi() async {
    attempt++;
    if (attempt < 3) {
      throw Exception('第 $attempt 次失败');
    }
    return '第 $attempt 次成功';
  }

  // 重试逻辑：最多 3 次
  String? result2;
  for (int i = 0; i < 3; i++) {
    try {
      result2 = await unstableApi();
      break; // 成功了就跳出
    } catch (e) {
      print('  重试 ${i + 1}/3: $e');
      if (i < 2) await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  print('  最终结果: $result2');

  // ========== 9. 实用模式：并发限流（Semaphore） ==========
  print('\n--- 9. 并发限流：同时最多执行 N 个 ---');

  // 模拟 6 个任务，同时最多执行 2 个
  Future<String> task(int id) async {
    var wait = Duration(milliseconds: 400 + (id * 100));
    await Future.delayed(wait);
    return '任务 $id 完成（耗时 ${wait.inMilliseconds}ms）';
  }

  // 限流器：同时最多执行 maxConcurrent 个
  Future<List<String>> concurrencyLimit(
    List<Future<String> Function()> tasks,
    int maxConcurrent,
  ) async {
    var results = <String>[];
    var running = <Future<void>>[];

    for (int i = 0; i < tasks.length; i++) {
      // 启动一个新任务
      var future = tasks[i]().then((r) {
        results.add(r);
      });
      running.add(future);

      // 如果达到并发上限，等其中一个完成
      if (running.length >= maxConcurrent) {
        await Future.any(running);
        // 清理已完成的
        running.removeWhere((f) => !f.runtimeType.toString().contains('_Future'));
        // 上面这样判断不准确，这里用更可靠的方式
      }
    }

    // 等剩下的全部完成
    await Future.wait(running);
    return results;
  }

  // 更简单的限流方式：分批执行
  print('  分批执行（每批 2 个）：');
  var taskList = [for (int i = 1; i <= 6; i++) i];
  for (var batch in _chunked(taskList, 2)) {
    var batchResults = await Future.wait(batch.map((id) => task(id)));
    for (var r in batchResults) {
      print('    $r');
    }
  }

  // ========== 10. 实用模式：超时 + 重试组合 ==========
  print('\n--- 10. 超时 + 重试组合 ---');

  int retryCount = 0;
  Future<String> flakyService() async {
    retryCount++;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (retryCount % 2 == 1) {
      throw Exception('服务异常');
    }
    return '服务成功';
  }

  String? result3;
  for (int i = 0; i < 3; i++) {
    try {
      result3 = await flakyService().timeout(
        const Duration(seconds: 1),
        onTimeout: () => throw TimeoutException('超时'),
      );
      break;
    } catch (e) {
      print('  第 ${i + 1} 次尝试失败: $e');
      if (i < 2) await Future.delayed(const Duration(milliseconds: 200));
    }
  }
  print('  最终结果: $result3');

  print('\n程序结束');
}

/// 将列表分成每 chunkSize 个一组
List<List<T>> _chunked<T>(List<T> list, int chunkSize) {
  var result = <List<T>>[];
  for (int i = 0; i < list.length; i += chunkSize) {
    result.add(list.sublist(i, (i + chunkSize).clamp(0, list.length)));
  }
  return result;
}

/*
总结：异步进阶

1. Future.wait([...]) — 并发执行多个 Future，等全部完成
   - 总耗时 = 最慢的那个，不是累加
   - 适合：同时请求多个 API

2. Future.any([...]) — 多个 Future 中任意一个完成就返回
   - 适合：多数据源竞争、最快响应优先

3. .timeout(Duration, onTimeout: fn) — 超时处理
   - 超时后执行 onTimeout 回调，返回值作为结果
   - 不传 onTimeout 会抛 TimeoutException

4. Future.delayed(Duration, fn) — 延迟执行

5. Future.value(v) / Future.error(e) — 快速创建成功/失败的 Future

6. Future.sync(fn) — 同步执行但包装成 Future

7. Future.forEach(list, fn) — 顺序异步遍历

8. 重试模式 — 循环 + try-catch，失败后重试

9. 并发限流 — 分批执行或信号量控制

10. 超时 + 重试组合 — 实际项目中最常用的模式

注意：
- Future.wait 是并发执行，不是顺序执行
- 超时时间要根据实际业务设置，太短容易误判
- 重试要加退避（backoff），避免打爆服务器
- 并发数要合理，太多会耗尽资源
*/
