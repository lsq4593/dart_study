// Dart 全课程综合练习题 — 第2题
// 知识点：类、继承、抽象类、Mixin、命名构造函数、运算符重载、callable class、factory

// 1. 抽象类 Animal
abstract class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  // 7. 命名构造函数 — 创建"访客"动物，年龄随机
  Animal.guest()
      : name = '访客',
        age = DateTime.now().millisecondsSinceEpoch % 10 + 1;

  // 抽象方法
  void makeSound();

  // 5. 运算符重载：实现 > 运算符，比较 age
  bool operator >(Animal other) => age > other.age;

  // 8. factory 构造函数 — 根据 type 返回不同子类实例
  factory Animal.create(String type, String name, int age) {
    switch (type) {
      case 'bird':
        return Bird(name, age);
      case 'duck':
        return Duck(name, age);
      case 'fish':
        return Fish(name, age);
      default:
        throw ArgumentError('未知的动物类型: $type');
    }
  }
}

// 2. mixin Flyable
mixin Flyable {
  void fly() => print('飞起来了');
}

// 3. mixin Swimmable
mixin Swimmable {
  void swim() => print('游起来了');
}

// 4. 具体动物类
class Bird extends Animal with Flyable {
  Bird(String name, int age) : super(name, age);

  @override
  void makeSound() => print('叽叽');
}

class Duck extends Animal with Flyable, Swimmable {
  Duck(String name, int age) : super(name, age);

  @override
  void makeSound() => print('嘎嘎');
}

class Fish extends Animal with Swimmable {
  Fish(String name, int age) : super(name, age);

  @override
  void makeSound() => print('...');
}

// 6. callable class：ZooKeeper
class ZooKeeper {
  final String name;

  ZooKeeper(this.name);

  String call(Animal animal) => '饲养员$name喂食了${animal.name}';
}

void main() {
  // 测试你的代码
  var bird = Animal.create('bird', '小鸟', 2);
  var duck = Animal.create('duck', '小鸭', 1);
  var fish = Animal.create('fish', '小鱼', 3);

  var animals = [bird, duck, fish];
  for (var animal in animals) {
    animal.makeSound();
  }

  (bird as Bird).fly();
  (duck as Duck).swim();

  var keeper = ZooKeeper('老张');
  print(keeper(bird)); // 饲养员老张喂食了小鸟

  print(bird > duck); // 比较年龄
}
