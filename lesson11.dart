// Dart 第十一课：命名参数与默认值

void main() {
  // 命名参数用 {} 包裹，调用时写参数名
  print(createUser(name: '小明', age: 25));
  print(createUser(name: '小红')); // age 用默认值

  // 位置参数也可以有默认值
  print(sayHello('小明'));
  print(sayHello('小明', '你好呀'));
}

// {} 表示命名参数，required 表示必传
String createUser({required String name, int age = 18}) {
  return '$name, $age 岁';
}

// [] 表示可选位置参数，带默认值
String sayHello(String name, [String greet = '你好']) {
  return '$greet, $name!';
}
