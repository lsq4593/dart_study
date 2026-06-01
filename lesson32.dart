// Dart 第三十二课：assert 断言

void main() {
  var user = createUser('小明', -25);
  print(user);

  // assert — 条件为 false 就抛异常
  // createUser('', 25);    // 取消注释试试：断言失败

  var score = 85;
  assert(score >= 0, '分数不能为负');
  print('分数: $score');
}

String createUser(String name, int age) {
  // 参数校验：条件不满足就抛异常
  assert(name.isNotEmpty, '名字不能为空');
  assert(age >= 0, '年龄不能为负');
  return '$name, $age岁';
}
