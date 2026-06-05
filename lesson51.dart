// Dart 第五十一课：Timer 定时器

import 'dart:async';

void main() async {
  print('========== Timer 示例 ==========');
  print('程序开始');

  // ========== 1. 延迟执行一次 ==========
  print('\n--- 1. 延迟执行 ---');
  Timer(Duration(seconds: 1), () {
    print('1秒后: 第一次延迟执行');
  });

  Timer(Duration(milliseconds: 500), () {
    print('0.5秒后: 我先执行');
  });

  // ========== 2. Timer.periodic 重复执行 ==========
  print('\n--- 2. 定时重复执行 ---');
  int count = 0;
  Timer.periodic(Duration(milliseconds: 300), (timer) {
    count++;
    print('第${count}次执行 (每300ms)');
    if (count >= 3) {
      timer.cancel();
      print('  定时器已取消');
    }
  });

  // ========== 3. 取消定时器 ==========
  print('\n--- 3. 取消定时器 ---');
  var cancelTimer = Timer(Duration(seconds: 5), () {
    print('这条不会执行，因为被取消了');
  });
  print('定时器是否活跃: ${cancelTimer.isActive}');
  cancelTimer.cancel();
  print('取消后是否活跃: ${cancelTimer.isActive}');
  // 重复取消不会报错
  cancelTimer.cancel();
  print('再次取消: 不会报错');

  // ========== 4. 倒计时示例 ==========
  print('\n--- 4. 倒计时 ---');
  int seconds = 5;
  Timer.periodic(Duration(seconds: 1), (timer) {
    print('倒计时: $seconds 秒');
    seconds--;
    if (seconds < 0) {
      timer.cancel();
      print('倒计时结束!');
    }
  });

  // ========== 5. Timer vs Future.delayed ==========
  print('\n--- 5. Future.delayed (对比) ---');
  Future.delayed(Duration(milliseconds: 800), () {
    print('0.8秒后: Future.delayed 执行');
  });

  // ========== 6. 模拟轮询 ==========
  print('\n--- 6. 模拟轮询（3次后停止） ---');
  int pollCount = 0;
  Timer.periodic(Duration(milliseconds: 500), (timer) {
    pollCount++;
    print('轮询第$pollCount次: 检查数据...');
    // 模拟某次轮询成功
    if (pollCount == 2) {
      print('  数据就绪!');
      timer.cancel();
    }
  });

  // 等待所有定时器执行完毕再退出
  print('\n等待定时器执行中...');
  await Future.delayed(Duration(seconds: 4));
  print('\n程序结束');
}

/*
总结：Timer 定时器

1. 一次性定时器
   Timer(Duration(秒), 回调)       — 延迟执行一次

2. 重复定时器
   Timer.periodic(Duration(秒), (timer) {
     timer.cancel();               — 在条件满足时取消
   })

3. 常用属性/方法
   timer.isActive   — 是否还在运行
   timer.cancel()   — 取消定时器（幂等，可多次调）

4. Timer vs Future.delayed
   
   Timer        可以取消，可以重复   → 定时任务、倒计时
   Future.delayed 不能取消，只能一次  → 简单的延迟操作

5. 注意
   - dart:async 自动导入，不用写 import
   - periodic 记得 cancel()，否则无限执行
   - 取消后 isActive 为 false
*/
