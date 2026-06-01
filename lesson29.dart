// Dart 第二十九课：static 静态成员

void main() {
  // 静态成员通过类名直接调，不需要创建对象
  print(Calculator.pi);
  print(Calculator.add(10, 20));

  // 普通成员必须通过对象调
  var calc = Calculator();
  calc.count = 1;
  calc.show();
}

class Calculator {
  // static — 属于类的，不属于某个对象
  static const double pi = 3.14159;

  static int add(int a, int b) => a + b;

  // 普通成员 — 属于对象的
  int count = 0;

  void show() {
    // 普通方法可以访问静态成员
    print('count: $count, pi: $pi');
  }
}
