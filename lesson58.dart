// Dart 第五十八课：Isolate 通信

import 'dart:isolate';

Future<void> main() async {
  print('========== Isolate 通信 ==========');

  // ========== 1. 基本：发一条消息 ==========
  print('\n--- 1. 单向通信 ---');
  var r1 = ReceivePort();
  await Isolate.spawn(sayHello, r1.sendPort);
  print('message: ${r1}');
  var msg1 = await r1.first;
  print('收到: $msg1');

  // ========== 2. 多次收发 ==========
  print('\n--- 2. 多次收发 ---');
  var r2 = ReceivePort();
  await Isolate.spawn(counter, r2.sendPort);

  // 收5条消息
  await for (var msg in r2.take(5)) {
    print('  收到: $msg');
  }

  // ========== 3. 双向通信 ==========
  print('\n--- 3. 双向通信 ---');
  var r3 = ReceivePort();
  await Isolate.spawn(echo, r3.sendPort);

  // 等 worker 启动，拿到它的 SendPort
  var workerPort = await r3.first as SendPort;

  // 发消息并等回复
  var replyPort = ReceivePort();
  workerPort.send(['你好, worker!', replyPort.sendPort]);
  var reply = await replyPort.first;
  print('  回复: $reply');

  // 再发一条
  var replyPort2 = ReceivePort();
  workerPort.send(['再发一条', replyPort2.sendPort]);
  var reply2 = await replyPort2.first;
  print('  回复: $reply2');

  // ========== 4. 传递复杂数据 ==========
  print('\n--- 4. 计算密集型任务 ---');
  var r4 = ReceivePort();
  await Isolate.spawn(computeFibonacci, r4.sendPort);

  // 发送参数并等结果
  var taskPort = await r4.first as SendPort;
  var resultPort = ReceivePort();
  taskPort.send([40, resultPort.sendPort]);
  var result = await resultPort.first;
  print('  fibonacci(40) = $result');

  // 再算一个
  var resultPort2 = ReceivePort();
  taskPort.send([42, resultPort2.sendPort]);
  var result2 = await resultPort2.first;
  print('  fibonacci(42) = $result2');

  // ========== 5. 并发对比 ==========
  print('\n--- 5. 并发加速对比 ---');
  var sw = Stopwatch()..start();

  // 同步执行
  fib(40);
  fib(42);
  print('  同步执行: ${sw.elapsedMilliseconds}ms');

  sw.reset();

  // 并发执行
  var r5a = ReceivePort();
  await Isolate.spawn(computeFib, [40, r5a.sendPort]);
  var r5b = ReceivePort();
  await Isolate.spawn(computeFib, [42, r5b.sendPort]);

  var results = await Future.wait([r5a.first, r5b.first]);
  print('  并发执行: ${sw.elapsedMilliseconds}ms');
  print('  结果: $results');

  // ========== 6. Isolate.run 对比 ==========
  print('\n--- 6. Isolate.run（简化的方式） ---');
  var sw2 = Stopwatch()..start();

  var r6a = await Isolate.run(() => fib(40));
  var r6b = await Isolate.run(() => fib(42));
  print('  Isolate.run 并发: ${sw2.elapsedMilliseconds}ms');
  print('  结果: [$r6a, $r6b]');

  print('\n程序结束');
}

// ========== 1. 单向通信 ==========
void sayHello(SendPort sendPort) {
  sendPort.send('你好，从 Isolate 发来的消息');
}

// ========== 2. 多次收发 ==========
void counter(SendPort sendPort) {
  for (int i = 1; i <= 5; i++) {
    sendPort.send(i);
  }
}

// ========== 3. 双向通信 ==========
void echo(SendPort sendPort) {
  // 先建一个 ReceivePort 给自己用
  var receiver = ReceivePort();

  // 把自己的 SendPort 发回主 Isolate
  sendPort.send(receiver.sendPort);

  // 监听消息
  receiver.listen((msg) {
    var data = msg as List;
    var text = data[0] as String;
    var replyTo = data[1] as SendPort;
    replyTo.send('echo: $text');
  });
}

// ========== 4. 计算任务 ==========
void computeFibonacci(SendPort sendPort) {
  var receiver = ReceivePort();
  sendPort.send(receiver.sendPort);

  receiver.listen((msg) {
    var data = msg as List;
    var n = data[0] as int;
    var replyTo = data[1] as SendPort;
    replyTo.send(fib(n));
  });
}

void computeFib(List<Object> args) {
  var n = args[0] as int;
  var sendPort = args[1] as SendPort;
  sendPort.send(fib(n));
}

// ========== 斐波那契（计算密集型） ==========
int fib(int n) {
  if (n <= 1) return n;
  return fib(n - 1) + fib(n - 2);
}

/*
总结：Isolate 通信

1. 单向通信
   var r = ReceivePort();               // 主 Isolate 收消息
   Isolate.spawn(worker, r.sendPort);   // 把发件地址传给 worker
   var msg = await r.first;             // 等一条消息

   void worker(SendPort sp) {
     sp.send('消息');                   // worker 发消息
   }

2. 双向通信
   worker 也创建自己的 ReceivePort
   把它的 sendPort 发回主 Isolate
   双方都有发送和接收能力

3. 消息类型
   基本类型、List、Map、SendPort 可以传递
   函数、对象（无构造函数）不能传递

4. 对比
   Isolate.run → 一次性任务，简单
   手动通信   → 持续交互，灵活

5. 注意
   Worker 里的 print 不会出现在主 Isolate 的 console
   复杂对象需要序列化后才能传递
   通信端口用完应该 close()
*/
