// Dart 第四课：运算符

void main() {
  // 算术运算
  int a = 10;
  int b = 3;

  print('$a + $b = ${a + b}');
  print('$a - $b = ${a - b}');
  print('$a * $b = ${a * b}');
  print('$a / $b = ${a / b}'); // 结果是 double
  print('$a ~/ $b = ${a ~/ b}'); // 取整 ~/
  print('$a % $b = ${a % b}'); // 取余

  // 比较运算
  print('${a > b}'); // true
  print('${a == b}'); // false

  // 逻辑运算
  bool isSunny = true;
  bool isWarm = true;
  print('去公园: ${isSunny && isWarm}'); // true
}
