// Dart 第三十五课：typedef 类型别名

void main() {
  // typedef 给复杂类型起个简短的名字
  Filter isAdult = (int age) => age >= 18;

  print(isAdult(25)); // true
  print(isAdult(15)); // false

  var users = [('小明', 25), ('小红', 17), ('小刚', 30)];
  var adults = users.where((u) => isAdult(u.$2));
  print('成年人: ${adults.map((u) => u.$1).toList()}');
}

// Filter 就是 (int) -> bool 的别名
typedef Filter = bool Function(int age);
