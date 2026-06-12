// Dart 全课程综合练习题 — 第7题
// 知识点：解构、switch表达式、if-case、sealed class、模式守卫

import 'dart:math';

// TODO: 用 sealed class 定义 Shape（圆、矩形、三角形）
// sealed class Shape {}
// class Circle extends Shape { final double r; ... }
// class Rectangle extends Shape { final double w, h; ... }
// class Triangle extends Shape { final double a, b, c; ... }

// 1. 用 switch 表达式实现 area(Shape) 函数，返回面积
// 2. 用 if-case 判断一个 Shape 是否是正方形（等边矩形）
// 3. 用模式解构从 Record 中取值

void main() {
  // 测试
  var shapes = <Shape>[
    Circle(5),
    Rectangle(4, 6),
    Triangle(3, 4, 5),
    Rectangle(4, 4), // 正方形
  ];
  
  for (var s in shapes) {
    print('面积: ${area(s)}');
    if (s case Rectangle(w: var w, h: var h) when w == h) {
      print('  这是个正方形!');
    }
  }
  
  // Record 解构
  var user = (name: '小明', age: 25, scores: [90, 85, 92]);
  // TODO: 用模式解构一次性取出 name 和 age
  // var (name: name, age: age) = user;
  print('用户: $name, $age 岁');
}
