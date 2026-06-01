// Dart 第三课：常量 final 和 const

void main() {
  // final - 运行时赋值，赋值后不可变
  final String name = '小明';
  final now = DateTime.now(); // 运行时确定
  print('$name, 现在时间: $now');
  print('$name, 现在时间: $now');
  print('$name, 现在时间: $now');
  print('$name, 现在时间: $now');
  // const - 编译时常量
  const double pi = 3.14159;
  const int hoursInDay = 24;
  print('圆周率: $pi');
  print('一天 $hoursInDay 小时');

  // 区别:
  // final 运行后确定值，const 编译时就确定
  // const 不能这样: const now = DateTime.now(); // 报错
}
