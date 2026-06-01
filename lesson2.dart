// Dart 第二课：变量

void main() {
  // var - 类型推断
  var name = '小明';
  print(name);

  // 显式类型
  // int 整数 double 浮点数  bool 布尔类型
  int age = 25;
  double height = 1.75;
  String greeting = '你好';
  bool isStudent = true;

  print('$greeting, 我是$name, $age岁');
  print('身高: ${height}m');
  print('是否学生: $isStudent');
}
