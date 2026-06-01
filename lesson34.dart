// Dart 第三十四课：运算符重载

void main() {
  var p1 = Point(1, 2);
  var p2 = Point(3, 4);

  var sum = p1 + p2;
  print('(${sum.x}, ${sum.y})'); // (4, 6)

  var diff = p1 - p2;
  print('(${diff.x}, ${diff.y})'); // (-2, -2)

  print(p1 == Point(1, 2)); // true
  p2 = Point(1, 2);
  print(p1 == p2); // false
}

class Point {
  final int x, y;
  const Point(this.x, this.y);

  // 重载 + 运算符
  Point operator +(Point other) {
    return Point(x + other.x, y + other.y);
  }

  // 重载 - 运算符
  Point operator -(Point other) {
    return Point(x - other.x, y - other.y);
  }

  // 重载 == 运算符
  @override
  bool operator ==(Object other) {
    return other is Point && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
