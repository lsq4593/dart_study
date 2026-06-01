// Dart 第三十课：getter 和 setter

void main() {
  var rect = Rectangle(5, 3);
  print('面积: ${rect.area}'); // getter，像属性一样用
  print('周长: ${rect.perimeter}');

  rect.height = 10;
  print('修改后面积: ${rect.area}');
}

class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  // getter — 像属性一样读，但背后是计算逻辑
  double get area => width * height;

  double get perimeter => 2 * (width + height);

  // setter — 像属性一样写
  set area(double value) {
    width = value / height;
    height = value / width;
  }
}
