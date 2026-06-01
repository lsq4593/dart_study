// Dart 第十六课：抽象类

void main() {
  var circle = Circle(5);
  print('圆面积: ${circle.area()}');
  circle.draw();

  var rect = Rectangle(4, 6);
  print('矩形面积: ${rect.area()}');

  rect.draw();
}

// abstract 表示抽象类，不能直接创建对象
abstract class Shape {
  double area(); // 抽象方法，没有方法体

  void draw() {
    print('画一个图形');
  }
}

class Circle extends Shape {
  double r;

  Circle(this.r);

  @override
  double area() => 3.14 * r * r;

  @override
  void draw() {
    print('画一个圆');
  }
}

class Rectangle extends Shape {
  double w, h;

  Rectangle(this.w, this.h);

  @override
  double area() => w * h;
}
