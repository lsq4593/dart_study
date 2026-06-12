// Dart 练习题 — 第22题：异步任务调度器
// 知识点：Future、Stream、Completer、Timer、async/await、泛型、Zone

/// 实现一个简单的任务调度器，支持延迟执行、定时重试、超时控制。
/// 完成下方 TODO 区域，使 main 函数能正确运行。

import 'dart:async';

// ========== TODO 区域 ==========

/// 1. 实现一个函数 Future<T> retry<T>(Future<T> Function() task, int maxAttempts)
///    - 执行 task，如果失败（抛出异常）则重试，最多重试 maxAttempts 次
///    - 每次重试前等待 500ms
///    - 如果所有尝试都失败，抛出最后一次的异常
///    - 提示：用 Future.delayed 实现等待，用递归或循环

// TODO: 实现 retry 函数



/// 2. 实现一个函数 Future<T> timeoutWithFallback<T>(
///        Future<T> Function() task, Duration timeout, T fallback)
///    - 执行 task，如果在 timeout 时间内未完成，返回 fallback
///    - 提示：用 Future.any 或 .timeout 加 catchError

// TODO: 实现 timeoutWithFallback 函数



/// 3. 实现一个类 TaskScheduler
///    - void schedule(Duration delay, void Function() action) — 延迟执行
///    - Stream<T> periodic<T>(Duration interval, T Function(int) generator) — 定时产生数据
///    - Future<void> stop() — 取消所有待执行任务，返回后不再有任务触发
///    - int get pendingCount — 当前待执行任务数
///    - 提示：内部用 Timer、StreamController 管理

// TODO: 实现 TaskScheduler 类



/// 4. 用 Completer 实现一个函数 Future<String> fetchWithCompleter()
///    - 模拟网络请求：2 秒后返回 "数据加载完成"
///    - 必须使用 Completer，不能用 async 函数

// TODO: 实现 fetchWithCompleter 函数



/// 5. 用 runZoned 实现一个隔离执行函数
///    void runIsolated(void Function() action, void Function(Object, StackTrace) onError)
///    在 Zone 里执行 action，如果抛出错误不崩掉程序，而是调用 onError

// TODO: 实现 runIsolated 函数



// ========== 测试代码（请勿修改）==========

void main() async {
  print('========== 异步任务调度器 ==========\n');

  // ---- 测试1：retry 重试 ----
  print('--- 测试1：retry 重试 ---');
  int attempt = 0;
  final result = await retry(() async {
    attempt++;
    if (attempt < 3) throw Exception('第$attempt次失败');
    return '第$attempt次成功';
  }, 5);
  print('结果: $result (共尝试$attempt次)');

  // ---- 测试2：timeoutWithFallback ----
  print('\n--- 测试2：超时降级 ---');
  final slow = await timeoutWithFallback(
    () => Future.delayed(const Duration(seconds: 2), () => '慢响应'),
    const Duration(milliseconds: 500),
    '（超时降级）',
  );
  print('慢任务结果: $slow');

  final fast = await timeoutWithFallback(
    () => Future.delayed(const Duration(milliseconds: 200), () => '快响应'),
    const Duration(seconds: 1),
    '（超时降级）',
  );
  print('快任务结果: $fast');

  // ---- 测试3：TaskScheduler ----
  print('\n--- 测试3：任务调度器 ---');
  final scheduler = TaskScheduler();
  
  print('待任务数: ${scheduler.pendingCount}');
  
  scheduler.schedule(const Duration(milliseconds: 100), () {
    print('  延迟100ms执行 ✅');
  });
  scheduler.schedule(const Duration(milliseconds: 200), () {
    print('  延迟200ms执行 ✅');
  });
  
  print('安排2个任务后: ${scheduler.pendingCount}');
  
  // 定时器：每秒产生一个数字
  int tick = 0;
  final subscription = scheduler
      .periodic(const Duration(milliseconds: 150), (i) => i)
      .take(4)
      .listen((n) {
    tick++;
    print('  定时器第${n + 1}次: tick ✅');
  });

  await Future.delayed(const Duration(seconds: 1));
  await subscription.cancel();
  await scheduler.stop();
  print('停止后待任务数: ${scheduler.pendingCount}');

  // ---- 测试4：Completer ----
  print('\n--- 测试4：Completer ---');
  final data = await fetchWithCompleter();
  print('获取数据: $data');

  // ---- 测试5：runZoned 隔离 ----
  print('\n--- 测试5：Zone 错误隔离 ---');
  runIsolated(
    () {
      print('  在 Zone 里执行...');
      Future.delayed(const Duration(milliseconds: 100), () {
        throw Exception('Zone 里的异步错误!');
      });
    },
    (error, stack) {
      print('  捕获到错误: $error');
    },
  );
  await Future.delayed(const Duration(milliseconds: 300));
  print('  程序没有崩溃 ✅');

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 异步任务调度器 ==========
  //
  // --- 测试1：retry 重试 ---
  // 结果: 第3次成功 (共尝试3次)
  //
  // --- 测试2：超时降级 ---
  // 慢任务结果: （超时降级）
  // 快任务结果: 快响应
  //
  // --- 测试3：任务调度器 ---
  // 待任务数: 0
  //   延迟100ms执行 ✅
  //   延迟200ms执行 ✅
  // 安排2个任务后: 2
  //   定时器第1次: tick ✅
  //   定时器第2次: tick ✅
  //   定时器第3次: tick ✅
  //   定时器第4次: tick ✅
  // 停止后待任务数: 0
  //
  // --- 测试4：Completer ---
  // 获取数据: 数据加载完成
  //
  // --- 测试5：Zone 错误隔离 ---
  //   在 Zone 里执行...
  //   捕获到错误: Exception: Zone 里的异步错误!
  //   程序没有崩溃 ✅
  //
  // ========== 测试完成 ==========
}
