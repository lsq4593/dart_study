// Dart 第四十一课：类修饰符

void main() {
  var dog = Dog('旺财');
  dog.bark();

  var robot = Robot('R2D2');
  robot.work();

  var flyable = Flyable('小鸟');
  flyable.fly();
}

// 不写修饰符：别的文件什么都能做
class Animal {
  String name;
  Animal(this.name);
}

// base：别的文件可以 extends 但不能 implements
// 子类也必须用 base 标记
base class Dog extends Animal {
  Dog(super.name);
  void bark() => print('$name 汪汪');
}

// interface：别的文件可以 implements 但不能 extends
interface class Flyable {
  String name;
  Flyable(this.name);
  void fly() => print('$name 飞行');
}

// 同一文件内可以 extends（跨文件不行）
class Bird extends Flyable {
  Bird(String name) : super(name);
}

// final：别的文件既不能 extends 也不能 implements
final class Robot {
  String name;
  Robot(this.name);
  void work() => print('$name 工作中');
}

// mixin class：既是普通类，又能当 mixin
mixin class Runner {
  void run() => print('跑');
}

class Cat extends Animal with Runner {
  Cat(super.name);
}

/*
对比：类修饰符

| 修饰符    | 跨文件 extends | 跨文件 implements |
|-----------|:---:|:---:|
| (不写)    | ✅ | ✅ |
| base      | ✅ | ❌ |
| interface | ❌ | ✅ |
| final     | ❌ | ❌ |
| sealed    | ❌ | ❌ |
| mixin class | ✅ | ✅ |

同一文件内不受这些限制约束
*/
