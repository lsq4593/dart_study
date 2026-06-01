// Dart 第二十五课：Record 记录

void main() {
  // Record 把多个值打包成一个，不用定义类
  var user = ('小明', 25);
  print('$user');
  print('${user.$1}, ${user.$2}');

  // 带命名的 Record，更清晰
  var student = (name: '小红', age: 24, score: 92);
  print('${student.name}, ${student.score}分');

  // 函数返回多个值很方便
  var result = divide(10, 3);
  print('商: ${result.$1}, 余: ${result.$2}');
}

// 返回两个值，不用专门建一个类
(int, int) divide(int a, int b) {
  return (a ~/ b, a % b);
}
