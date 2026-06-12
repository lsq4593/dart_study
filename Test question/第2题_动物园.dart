// Dart 全课程综合练习题 — 第2题
// 知识点：类、继承、抽象类、Mixin、命名构造函数、运算符重载、callable class、factory

// TODO: 
// 1. abstract class Animal — 有 name, age, 抽象方法 makeSound()
// 2. mixin Flyable — 有 fly() 方法
// 3. mixin Swimmable — 有 swim() 方法
// 4. 具体动物类（继承 Animal + 混入相应 mixin）
//    - Bird: 继承 Animal + Flyable, makeSound 输出"叽叽"
//    - Duck: 继承 Animal + Flyable + Swimmable, makeSound 输出"嘎嘎"
//    - Fish: 继承 Animal + Swimmable, makeSound 输出"..."
// 5. 运算符重载：两个 Animal 比较 age（实现 > 运算符）
// 6. callable class：ZooKeeper 类，call() 返回"饲养员 name 喂食了 animalName"
// 7. 命名构造函数：Animal.guest() 创建名字为"访客"、年龄随机的动物
// 8. factory构造函数：Animal 根据传入的 type 返回不同子类实例

void main() {
  // 测试你的代码
  var bird = Animal.create('bird', '小鸟', 2);
  var duck = Animal.create('duck', '小鸭', 1);
  var fish = Animal.create('fish', '小鱼', 3);
  
  var animals = [bird, duck, fish];
  for (var animal in animals) {
    animal.makeSound();
  }
  
  bird.fly();
  duck.swim();
  
  var keeper = ZooKeeper('老张');
  print(keeper(bird)); // 饲养员老张喂食了小鸟
  
  print(bird > duck); // 比较年龄
}
