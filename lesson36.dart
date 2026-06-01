// Dart 第三十六课：callable class 可调用的类

void main() {
  var add5 = Adder(5);
  print(add5(10)); // 15
  print(add5(20)); // 25

  var greet = Greeter('你好');
  print(greet('小明'));
  print(greet('小红'));
}

// 实现 call() 方法，类的实例就可以像函数一样调用
class Adder {
  final int n;
  Adder(this.n);

  int call(int x) => x + n;
}

class Greeter {
  final String prefix;
  Greeter(this.prefix);

  String call(String name) => '$prefix, $name!';
}
