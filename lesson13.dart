// Dart 第十三课：命名构造函数

void main() {
  // 使用命名构造函数创建对象
  var p1 = Person('小明', 25);
  var p2 = Person.guest();       // 访客
  var p3 = Person.fromBirthday('小红', 2000);

  p1.sayHi();
  p2.sayHi();
  p3.sayHi();
}

class Person {
  String name;
  int age;

  // 普通构造函数
  Person(this.name, this.age);

  // 命名构造函数
  Person.guest() : this('访客', 18);

  // 命名构造函数 + 初始化列表
  Person.fromBirthday(String name, int birthYear)
      : this(name, DateTime.now().year - birthYear);

  void sayHi() {
    print('我叫$name, $age岁');
  }
}
