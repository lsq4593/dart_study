// Dart 练习题 — 第27题：学生成绩系统 — 缓存与异步加载
// 知识点：Completer、Future.timeout、重试机制、缓存策略、Duration、DateTime
//
// 实现一个带缓存和超时降级的学生成绩加载系统。
// 完成下方 TODO 区域，使 main 函数能正确运行。

import 'dart:async';

// ========== TODO 区域 ==========

/// 1. 定义 CacheEntry<T> 类（缓存条目）
///    - final T data
///    - final DateTime createdAt
///    - bool isExpired(Duration ttl) → 如果 now - createdAt > ttl 返回 true

// TODO: 实现 CacheEntry 类


/// 2. 定义 DataSource 类（数据源，模拟远程加载）
///    - final String name (数据源名称)
///    - final Duration delay (模拟加载耗时)
///    - final bool shouldFail (是否应该失败)
///    - int callCount = 0 (被调次数)
///    - Future<Map<String, int>> fetch() 返回成绩数据
///      格式: {'学生_001': 分数, ...}
///      每次被调 callCount +1
///      如果 shouldFail 为 true，抛出 Exception
///      否则延迟 delay 后返回 10 个学生的随机成绩（用 Random，种子递增）
///    - 需 import 'dart:math' 用 Random

// TODO: 实现 DataSource 类


/// 3. 实现一个 retry 函数
///    Future<T> retry<T>(Future<T> Function() task, {int maxAttempts = 3, Duration delay = Duration(milliseconds: 200)})
///    - 执行 task，失败则重试，最多 maxAttempts 次
///    - 每次重试前等待 delay 时间
///    - 所有重试都失败则抛出最后一次异常

// TODO: 实现 retry 函数


/// 4. 定义一个 GradeCache 类（成绩缓存）
///    - final Duration ttl (缓存有效期)
///    - final Map<String, CacheEntry<Map<String, int>>> _store = {}
///    - Future<Map<String, int>> get(String key, DataSource source)
///      ① 如果缓存中有且未过期，直接返回缓存数据
///      ② 否则调用 source.fetch()，获取后存入缓存再返回
///      ③ 如果 fetch 失败，重试（用 retry），最多 2 次
///      ④ 如果重试仍失败，尝试使用过期缓存（如果有）
///      ⑤ 如果连过期缓存都没有，抛异常
///    - void invalidate(String key) → 删除缓存
///    - void clear() → 清空缓存
///    - int get cachedCount → 缓存条目数

// TODO: 实现 GradeCache 类


/// 5. 实现一个函数 Future<T> timeoutWithCache<T>(
///        Future<T> Function() task, Duration timeout, T Function() fallback)
///    - 用 Completer 实现
///    - 执行 task，如果在 timeout 内完成则返回结果
///    - 如果超时，调用 fallback 返回降级数据

// TODO: 实现 timeoutWithCache 函数


// ========== 测试代码（请勿修改）==========

void main() async {
  print('========== 学生成绩系统 — 缓存与异步加载 ==========\n');

  // ---- 测试1：CacheEntry ----
  print('--- 测试1：CacheEntry ---');
  final entry = CacheEntry({'test': 100});
  await Future.delayed(const Duration(milliseconds: 10));
  print('  未过期: ${!entry.isExpired(const Duration(seconds: 1))} ✅');
  print('  已过期: ${entry.isExpired(Duration.zero)} ✅');

  // ---- 测试2：DataSource ----
  print('\n--- 测试2：DataSource ---');
  final normalSource = DataSource('正常源', Duration(milliseconds: 100), false);
  final data = await normalSource.fetch();
  print('  数据源: ${normalSource.name}');
  print('  被调次数: ${normalSource.callCount}');
  print('  返回数据: ${data.length} 人');

  // ---- 测试3：retry 重试 ----
  print('\n--- 测试3：retry 重试 ---');
  int attempt = 0;
  final retryResult = await retry(() async {
    attempt++;
    if (attempt < 3) throw Exception('第$attempt次失败');
    return '第$attempt次成功';
  }, maxAttempts: 5);
  print('  结果: $retryResult (尝试$attempt次)');

  // ---- 测试4：GradeCache 缓存 ----
  print('\n--- 测试4：GradeCache 缓存 ---');
  final cache = GradeCache(ttl: const Duration(seconds: 5));
  final source1 = DataSource('班级1', Duration(milliseconds: 200), false);

  // 第一次加载（走网络）
  print('  第一次加载(应该走网络)...');
  var class1 = await cache.get('class_1', source1);
  print('  获取到 ${class1.length} 条数据');
  print('  数据源被调次数: ${source1.callCount}');
  print('  缓存条目数: ${cache.cachedCount}');

  // 第二次加载（走缓存）
  print('\n  第二次加载(应该走缓存)...');
  var class1again = await cache.get('class_1', source1);
  print('  获取到 ${class1again.length} 条数据');
  print('  数据源被调次数: ${source1.callCount}（未增加 ✅）');

  // 清除缓存
  cache.invalidate('class_1');
  print('\n  清除缓存后...');
  print('  缓存条目数: ${cache.cachedCount}');

  // ---- 测试5：超时降级 ----
  print('\n--- 测试5：超时降级 ---');
  final slowResult = await timeoutWithCache(
    () => Future.delayed(const Duration(seconds: 2), () => '慢响应'),
    const Duration(milliseconds: 300),
    () => '（超时降级数据）',
  );
  print('  慢任务: $slowResult');

  final fastResult = await timeoutWithCache(
    () => Future.delayed(const Duration(milliseconds: 100), () => '快响应'),
    const Duration(seconds: 1),
    () => '（超时降级数据）',
  );
  print('  快任务: $fastResult');

  // ---- 测试6：失败+过期缓存兜底 ----
  print('\n--- 测试6：过期缓存兜底 ---');
  final failSource = DataSource('不稳定源', Duration(milliseconds: 100), true);
  final cache2 = GradeCache(ttl: const Duration(seconds: 1));

  // 先成功加载一次
  print('  先成功加载...');
  await cache2.get('unstable', DataSource('稳定源', Duration(milliseconds: 50), false));

  // 等缓存过期
  await Future.delayed(const Duration(milliseconds: 1100));

  // 此时数据源会失败，但有过期缓存兜底
  print('  用失败源加载(应有过期缓存兜底)...');
  try {
    final fallbackData = await cache2.get('unstable', failSource);
    print('  兜底成功 ✅ 获得 ${fallbackData.length} 条过期缓存数据');
  } catch (e) {
    print('  兜底失败 ❌ $e');
  }

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 学生成绩系统 — 缓存与异步加载 ==========
  //
  // --- 测试1：CacheEntry ---
  //   未过期: true ✅
  //   已过期: true ✅
  //
  // --- 测试2：DataSource ---
  //   数据源: 正常源
  //   被调次数: 1
  //   返回数据: 10 人
  //
  // --- 测试3：retry 重试 ---
  //   结果: 第3次成功 (尝试3次)
  //
  // --- 测试4：GradeCache 缓存 ---
  //   第一次加载(应该走网络)...
  //   获取到 10 条数据
  //   数据源被调次数: 1
  //   缓存条目数: 1
  //
  //   第二次加载(应该走缓存)...
  //   获取到 10 条数据
  //   数据源被调次数: 1（未增加 ✅）
  //
  //   清除缓存后...
  //   缓存条目数: 0
  //
  // --- 测试5：超时降级 ---
  //   慢任务: （超时降级数据）
  //   快任务: 快响应
  //
  // --- 测试6：过期缓存兜底 ---
  //   先成功加载...
  //   用失败源加载(应有过期缓存兜底)...
  //   兜底成功 ✅ 获得 10 条过期缓存数据
  //
  // ========== 测试完成 ==========
}
