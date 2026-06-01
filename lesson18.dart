// Dart 第十八课：Mixin 混入

void main() {
  var dog = Dog('旺财');
  dog.run();
  dog.swim();
}

// mixin 定义可复用的功能
mixin Runner {
  void run() => print('跑起来了');
}

mixin Swimmer {
  void swim() => print('游起来了');
}

class Animal {
  String name;
  Animal(this.name);
}

// with 把 mixin 的功能混入类中
class Dog extends Animal with Runner, Swimmer {
  Dog(String name) : super(name);
}
