// Dart 第十四课：继承

void main() {
  var dog = Dog('旺财', 3, '棕色');
  dog.bark(); // 自己的方法
  dog.sleep(); // 继承来的方法

  var cat = Cat('咪咪', 2);
  cat.sleep();
}

// 父类
class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  void sleep() {
    print('$name 睡觉了');
  }
}

// 子类用 extends 继承
class Dog extends Animal {
  String color;

  Dog(String name, int age, this.color) : super(name, age);

  void bark() {
    print('$name 汪汪叫');
  }
}

class Cat extends Animal {
  Cat(String name, int age) : super(name, age);
}
