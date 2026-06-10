// Dart 第六十六课：Completer — 手动控制 Future

import 'dart:async';

void main() async {
  print('========== Completer 手动控制 Future ==========');

  // ========== 1. 基本用法：手动完成 Future ==========
  print('\n--- 1. 基本用法 ---');

  // 创建一个 Completer，它关联一个 Future
  var completer = Completer<String>();
  var future = completer.future;  // 这就是要返回的 Future

  // 此时 Future 还没完成
  print('  Future 是否已完成: ${future.runtimeType}');

  // 在别的地方手动完成它
  Future.delayed(const Duration(milliseconds: 500), () {
    completer.complete('手动完成的数据');
  });

  var result = await future;
  print('  拿到结果: $result');

  // ========== 2. 手动失败 ==========
  print('\n--- 2. 手动失败 ---');

  var c2 = Completer<int>();
  Future.delayed(const Duration(milliseconds: 300), () {
    c2.completeError(Exception('出错了'));
  });

  try {
    await c2.future;
  } catch (e) {
    print('  捕获到: $e');
  }

  // ========== 3. 实用场景：回调转 Future ==========
  print('\n--- 3. 回调函数 → Future ---');
  // 很多老 API 用回调，用 Completer 可以包装成 Future

  // 模拟一个回调风格的函数
  void loadData(void Function(String) onSuccess, void Function(Object) onError) {
    Future.delayed(const Duration(milliseconds: 400), () {
      // 模拟成功
      onSuccess('回调返回的数据');
      // 模拟失败就用 onError
    });
  }

  // 用 Completer 包装成 Future
  Future<String> loadDataAsync() {
    var c = Completer<String>();
    loadData(
      (data) => c.complete(data),
      (error) => c.completeError(error),
    );
    return c.future;
  }

  var data = await loadDataAsync();
  print('  包装后: $data');

  // ========== 4. 实用场景：超时控制 ==========
  print('\n--- 4. 超时控制（手动实现）---');

  Future<String> fetchWithTimeout(int ms) {
    var c = Completer<String>();

    // 正常请求
    Future.delayed(const Duration(milliseconds: 1500), () {
      // 如果还没完成，就正常返回
      if (!c.isCompleted) {
        c.complete('正常返回');
      }
    });

    // 超时检测
    Future.delayed(Duration(milliseconds: ms), () {
      if (!c.isCompleted) {
        c.completeError(TimeoutException('请求超时'));
      }
    });

    return c.future;
  }

  try {
    var r = await fetchWithTimeout(1000);  // 1秒超时
    print('  结果: $r');
  } catch (e) {
    print('  超时: $e');  // 服务端 1500ms > 超时 1000ms
  }

  // ========== 5. 实用场景：一次性事件 ==========
  print('\n--- 5. 一次性事件 ---');
  // 比如等待用户第一次点击、等待 App 初始化完成

  var appReady = Completer<void>();

  // 模拟初始化
  Future.delayed(const Duration(milliseconds: 600), () {
    print('  App 初始化完成');
    appReady.complete();
  });

  // 等初始化完成再继续
  await appReady.future;
  print('  继续执行后续操作');

  // ========== 6. 注意事项：只能 complete 一次 ==========
  print('\n--- 6. 不能重复 complete ---');

  var c6 = Completer<String>();
  c6.complete('第一次');
  // c6.complete('第二次');  // ❌ 运行时报错！Future 已经完成

  // 安全的做法：先检查 isCompleted
  if (!c6.isCompleted) {
    c6.complete('安全完成');
  } else {
    print('  Future 已经完成了，忽略');
  }

  print('  最终结果: ${await c6.future}');  // 还是"第一次"

  // ========== 7. StreamController 的关联 ==========
  print('\n--- 7. Completer 与 StreamController ---');
  // StreamController 内部就是用 Completer 实现的

  var controller = StreamController<String>();
  controller.stream.listen((data) {
    print('  收到流数据: $data');
  });

  controller.add('数据1');
  controller.add('数据2');
  controller.close();

  // controller.done 就是一个 Future（内部是 Completer）
  await controller.done;
  print('  流已关闭');

  print('\n程序结束');
}

/*
总结：Completer

1. 创建：Completer<T>() → .future 拿到关联的 Future
2. 完成：.complete(value)       → 成功
         .completeError(error)  → 失败
3. 检查：.isCompleted → 是否已完成
4. 只能 complete 一次，重复调用会报错

用途：
  - 把回调风格的 API 包装成 Future（回调→异步）
  - 自定义超时控制
  - 等待一次性事件完成（如 App 初始化）
  - 手动控制异步流程

对比：普通 Future vs Completer

| | 普通 Future | Completer |
|---|---|---|
| 谁控制完成 | async 函数自动 | **你手动调用 complete()** |
| 适合场景 | 函数内部自己决定何时返回 | 需要外部/回调触发完成 |
| 灵活性 | 低（固定逻辑） | 高（可以在任何地方 complete） |
| 安全性 | 自动，不会忘记 | 忘了 complete 就永远挂起 |

注意：
  - 用 Completer 时一定记得 complete（或 completeError）
  - 不 complete 的 Future 永远 pending，会内存泄漏
  - 可以用 .isCompleted 防止重复 complete
*/
