// Dart 第六十八课：Zone — 区域隔离与错误捕获

import 'dart:async';

void main() {
  print('========== Zone 区域 ==========');

  // ========== 1. runZoned — 隔离错误 ==========
  print('\n--- 1. runZoned：错误隔离 ---');
  // 🏛️ dart:async API — runZoned

  runZoned(() {
    // 在这个区域里抛出的错误，不会崩掉整个程序
    print('  🌟 进入 Zone');
    Future.delayed(const Duration(milliseconds: 200), () {
      throw Exception('Zone 里的异步错误');
    });
  }, onError: (Object error, StackTrace stack) {
    print('  ✅ onError 捕获到: $error');
  });

  awaitFuture('  Zone 外继续执行');

  // ========== 2. runZonedGuarded — 保护根区域 ==========
  print('\n--- 2. runZonedGuarded：保护根区域 ---');
  // 🏛️ dart:async API — runZonedGuarded

  runZonedGuarded(() {
    // 这里面的所有错误都不会崩程序
    throw Exception('根区域错误');
    // 未捕获的异步错误也会被这里捕获
  }, (Object error, StackTrace stack) {
    print('  🛡️ 捕获: $error');
  });

  // ========== 3. Zone.current — 获取当前 Zone ==========
  print('\n--- 3. Zone.current：当前 Zone ---');
  // 🏛️ dart:async API — Zone.current

  print('  当前 Zone: ${Zone.current}');

  // 创建子 Zone
  var childZone = Zone.root.fork(
    specification: ZoneSpecification(),
    zoneValues: {'name': '子区域'},
  );

  childZone.run(() {
    print('  子 Zone: ${Zone.current}');
    print('  子 Zone 名称: ${Zone.current['name']}');
  });

  // ========== 4. zoneValues — 传递上下文 ==========
  print('\n--- 4. zoneValues：传递上下文 ---');
  // 🏛️ dart:async API — zoneValues

  runZoned(
    () {
      // 从 Zone 里取出用户信息
      var user = Zone.current['user'];
      print('  🧑 当前用户: $user');
    },
    zoneValues: {
      'user': '小明',
      'token': 'abc123',
      'isAdmin': true,
    },
  );

  // ========== 5. ZoneSpecification — 拦截操作 ==========
  print('\n--- 5. ZoneSpecification：拦截操作 ---');
  // 🏛️ dart:async API — ZoneSpecification

  var spec = ZoneSpecification(
    // 拦截 print
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      parent.print(zone, '  [Zone日志] $line');
    },
    // 拦截 setTimeout / Timer
    createTimer: (Zone self, ZoneDelegate parent, Zone zone, Duration duration,
        void Function() f) {
      print('  ⏰ 创建定时器: ${duration.inMilliseconds}ms');
      return parent.createTimer(zone, duration, f);
    },
  );

  runZoned(() {
    print('  这是一条被拦截的 print');
    Timer(const Duration(milliseconds: 100), () {
      print('  定时器触发了');
    });
  }, zoneSpecification: spec);

  awaitFuture('  等定时器执行完');

  // ========== 6. 实用：全剧错误兜底 ==========
  print('\n--- 6. 实用：全剧错误兜底 ---');

  // 在 main 最外层用 runZonedGuarded 包裹，防止任何未捕获异常崩溃
  runZonedGuarded(() {
    // 这里是主程序入口
    print('  🚀 程序启动');

    // 模拟各种错误
    Future.delayed(const Duration(milliseconds: 100), () {
      throw FormatException('数据格式错误');
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      throw TimeoutException('请求超时');
    });
  }, (Object error, StackTrace stack) {
    print('  ❌ 未捕获错误: $error');
    // 这里可以上报错误日志
    print('  📮 错误已上报到服务器');
  });

  awaitFuture('  等待异步错误触发');

  // ========== 7. 实用：请求链路追踪 ==========
  print('\n--- 7. 实用：链路追踪 ---');
  // 🏛️ dart:async API — Zone 嵌套实现链路 ID

  Future<String> fetchData(String api) {
    // 从当前 Zone 取请求 ID
    var requestId = Zone.current['requestId'] ?? '无';
    var startTime = DateTime.now();
    print('  [请求 $requestId] 开始 $api');

    return Future.delayed(const Duration(milliseconds: 300), () {
      print('  [请求 $requestId] 结束 $api（耗时 ${DateTime.now().difference(startTime).inMilliseconds}ms）');
      return '$api 结果';
    });
  }

  // 每个请求用一个独立 Zone，带 requestId
  for (int i = 1; i <= 3; i++) {
    runZoned(
      () => fetchData('/api/user/$i'),
      zoneValues: {'requestId': 'REQ-00$i'},
    );
  }

  awaitFuture('  等请求完成');

  print('\n程序结束');
}

/// 🏛️ dart:async API — Future.delayed
Future<void> awaitFuture(String msg) async {
  await Future.delayed(const Duration(milliseconds: 500));
  print('  $msg');
}

/*
总结：Zone 区域

1. runZoned(fn, onError)     — 隔离错误，不崩程序
2. runZonedGuarded(fn, cb)   — 保护根区域，兜底所有未捕获异常
3. Zone.current              — 获取当前运行所在的区域
4. zoneValues                — 在 Zone 里传递上下文（类似"线程局部变量"）
5. ZoneSpecification         — 拦截 print、Timer、microtask 等操作
6. 实用：全剧错误兜底         — main 最外层包裹，防止崩溃
7. 实用：链路追踪             — 每个请求一个 Zone，传递 requestId

对比：try-catch vs Zone

| | try-catch | Zone |
|---|---|---|
| 捕获范围 | 同一代码块 | **整个区域（含异步）** |
| 跨异步？ | ❌ 不能 catch 异步错误 | ✅ 能 |
| 传递数据 | ❌ 需要参数传递 | ✅ zoneValues |
| 拦截操作 | ❌ | ✅ 可拦截 print/Timer 等 |

注意：
- runZoned 的 onError 只能捕获 Zone 内的错误
- runZonedGuarded 捕获所有未捕获的异常（替代全局 try-catch）
- zoneValues 是 Map<Symbol/String, dynamic>，用 [] 取值
- Zone.fork 创建子 Zone，继承父 Zone 的值和设定
- Zone 不会自动隔离错误，需要主动处理
*/
