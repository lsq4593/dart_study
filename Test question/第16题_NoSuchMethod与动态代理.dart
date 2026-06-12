// Dart 全课程综合练习题 — 第16题
// 知识点：noSuchMethod、callable class、typedef

// TODO:
// 1. 用 noSuchMethod 实现一个 LoggingProxy
//    - 拦截所有方法调用，打印方法名和参数
//    - 记录调用次数
//    - 可以统计所有调用的耗时

// 2. 实现一个 ValidationProxy
//    - 通过注解（模拟）标记哪些参数需要校验非空
//    - 拦截调用，先校验再执行

// 3. callable class 实现一个简单的函数链
//    - Chain 类，每次 call() 返回自身，可以连续调用
//    - chain.add(1).add(2).add(3).result 返回 [1,2,3]

// 4. typedef 定义 Handler = void Function(String event)
//    用 List<Handler> 实现事件分发

// TODO: 实现

// typedef Handler = ...

class LoggingProxy {
  // TODO: 用 noSuchMethod 拦截
  // @override
  // void noSuchMethod(Invocation invocation) { ... }
}

class CallChain {
  // TODO: callable class，支持链式调用
}

void main() {
  // 测试 LoggingProxy
  dynamic proxy = LoggingProxy();
  proxy.sayHello('小明', 25);
  proxy.add(1, 2, 3);
  print('调用次数: ${proxy.callCount}');
  
  // 测试 CallChain
  var chain = CallChain();
  chain(1)(2)(3);
  print('链式结果: ${chain.result}'); // [1, 2, 3]
  
  // 测试事件分发
  var handlers = <Handler>[];
  handlers.add((event) => print('处理器1: $event'));
  handlers.add((event) => print('处理器2: $event'));
  for (var h in handlers) {
    h('用户登录');
  }
}
