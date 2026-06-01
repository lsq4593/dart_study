// Dart 第三十三课：模式匹配解构

void main() {
  // 解构 List
  var list = [1, 2, 3];
  var [a, b, c] = list;
  print('$a, $b, $c');    // 1, 2, 3

  // 解构 Map
  var info = {'name': '小明', 'age': 25};
  var {'name': name, 'age': age} = info;
  print('$name, $age岁');

  // 解构 Record
  var user = ('小红', 24);
  var (name2, age2) = user;
  print('$name2, $age2岁');

  // 解构对象
  var point = Point(3, 4);
  var Point(:x, :y) = point;
  print('x=$x, y=$y');
}

class Point {
  final int x, y;
  const Point(this.x, this.y);
}
