// Dart 第五十二课：StreamController 流控制

import 'dart:async';

Future<void> main() async {
  print('========== StreamController 基础 ==========');

  // 1. 基本用法
  print('\n--- 1. 基本：手动 add 数据 ---');
  var c1 = StreamController<String>();

  c1.stream.listen((data) {
    print('  收到: $data');
  });

  c1.add('你好');
  c1.add('世界');
  c1.add('Dart');
  c1.close();
  await c1.done;

  // 2. 三种事件
  print('\n--- 2. 三种事件监听 ---');
  var c2 = StreamController<int>();

  c2.stream.listen(
    (data) => print('  数据: $data'),
    onError: (err) => print('  错误: $err'),
    onDone: () => print('  流已关闭'),
  );

  c2.add(10);
  c2.add(20);
  c2.addError('出错了');
  c2.add(30);
  c2.close();
  await c2.done;

  // 3. Timer 定时产生数据
  print('\n--- 3. Timer 模拟传感器读数 ---');
  var c3 = StreamController<int>();
  int count = 0;
  var c3done = Completer<void>();

  c3.stream.listen((data) {
    print('  传感器读数: $data');
  }, onDone: () => c3done.complete());

  Timer.periodic(Duration(milliseconds: 300), (timer) {
    count++;
    c3.add(count * 10);
    if (count >= 5) {
      timer.cancel();
      c3.close();
    }
  });

  await c3done.future;
  print('  (传感器示例结束)');

  // 4. 广播流
  print('\n--- 4. 广播流：允许多次监听 ---');
  var c4 = StreamController<int>.broadcast();
  var c4done = Completer<void>();

  c4.stream.listen((d) => print('  监听者A: $d'));
  c4.stream.listen((d) => print('  监听者B: $d'));
  c4.stream.listen((d) => print('  监听者C: $d'), onDone: () => c4done.complete());
  c4.add(100);
  c4.add(200);
  c4.close();
  await c4done.future;

  // 5. 流方法
  print('\n--- 5. 流方法（where / map / take） ---');
  var c5 = StreamController<int>();
  var c5done = Completer<void>();

  c5.stream
      .where((n) => n.isEven)
      .map((n) => '  数字$n')
      .take(3)
      .listen((data) => print(data), onDone: () => c5done.complete());

  for (var i = 1; i <= 10; i++) {
    c5.add(i);
  }
  c5.close();
  await c5done.future;

  // 6. 搜索防抖
  print('\n--- 6. 模拟搜索防抖 ---');
  var c6 = StreamController<String>();
  var c6done = Completer<void>();

  c6.stream.listen((query) {
    print('  搜索: $query');
  }, onDone: () => c6done.complete());

  for (var text in ['D', 'Da', 'Dar', 'Dart']) {
    c6.add(text);
  }
  c6.close();
  await c6done.future;

  // 7. 回调转 Stream
  print('\n--- 7. 将回调转为 Stream ---');
  var c7 = StreamController<String>();
  var c7done = Completer<void>();

  c7.stream.listen((label) {
    print('  按钮 "$label" 被点击');
  }, onDone: () => c7done.complete());

  void onButtonClick(String label) => c7.add(label);

  onButtonClick('登录');
  onButtonClick('注册');
  onButtonClick('退出');

  c7.close();
  await c7done.future;

  print('\n程序结束');
}
