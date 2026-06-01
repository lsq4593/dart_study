// Dart 第十课：类与对象

void main() {
  // 创建对象
  var dog = Animal('旺财', 3);
  dog.bark();
  print('${dog.name}, ${dog.age}岁');
}

// 定义类
class Animal {
  String name;
  int age;

  // 构造函数
  Animal(this.name, this.age);

  void bark() {
    print('${this.name}: 汪汪!');
    print('${name}: 汪汪汪!');
  }
}
