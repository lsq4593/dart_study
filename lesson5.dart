// Dart 第五课：条件判断 if / else

void main() {
  int score = 85;

  if (score >= 90) {
    print('优秀');
  } else if (score >= 60) {
    print('及格');
  } else {
    print('不及格');
  }

  // 三元运算符
  int age = 20;
  String result = age >= 18 ? '成年' : '未成年';
  print('$age岁: $result');
}
