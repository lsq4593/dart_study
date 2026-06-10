// Dart 第七十课：泛型进阶 — 约束、多参数、协变

import 'dart:math';

// ========== 泛型类 ==========
class Pair<K, V> {
  final K first;
  final V second;
  const Pair(this.first, this.second);
  @override
  String toString() => '($first, $second)';
}

// ========== 泛型接口 ==========
abstract class Cache<T> {
  T? get(String key);
  void set(String key, T value);
}

class LocalCache<T> implements Cache<T> {
  final _store = <String, T>{};
  @override
  T? get(String key) => _store[key];
  @override
  void set(String key, T value) {
    _store[key] = value;
    print('  缓存: $key → $value');
  }
}

// ========== covariant 演示 ==========
class Animal {
  void feed(covariant Animal animal) {
    print('  Animal 喂食');
  }
}

class Dog extends Animal {
  @override
  void feed(covariant Dog dog) {
    print('  Dog 喂食');
  }
}

// ========== 泛型建造者 ==========
class QueryBuilder<T> {
  final List<String> _conditions = [];
  QueryBuilder<T> where(String condition) {
    _conditions.add(condition);
    return this;
  }
  QueryBuilder<T> orderBy(String field) {
    _conditions.add('ORDER BY $field');
    return this;
  }
  QueryBuilder<T> limit(int count) {
    _conditions.add('LIMIT $count');
    return this;
  }
  String build() => _conditions.join(' ');
}

// ========== 泛型类型别名 ==========
typedef Transformer<T, R> = R Function(T input);
typedef Predicate<T> = bool Function(T value);

void main() {
  print('========== 泛型进阶 ==========');

  // ========== 1. 泛型约束 extends ==========
  print('\n--- 1. 泛型约束（T extends 类型）---');
  // 🏛️ dart:core API — 泛型约束

  double sum<T extends num>(List<T> list) {
    double total = 0;
    for (var n in list) {
      total += n.toDouble();
    }
    return total;
  }

  print('  int 列表: ${sum<int>([1, 2, 3])}');       // 6.0
  print('  double 列表: ${sum<double>([1.5, 2.5])}'); // 4.0
  // sum<String>(['a', 'b']);  // ❌ 编译报错

  // ========== 2. 多个泛型参数 ==========
  print('\n--- 2. 多个泛型参数 ---');

  var pair1 = Pair<String, int>('年龄', 25);
  var pair2 = Pair<String, String>('name', '小明');
  var pair3 = Pair('key', true);  // 🏛️ dart:core API — 自动推断

  print('  $pair1');
  print('  $pair2');
  print('  $pair3');

  // ========== 3. 泛型方法 ==========
  print('\n--- 3. 泛型方法 ---');
  // 🏛️ dart:core API — 泛型方法

  T? firstOrNull<T>(List<T> list) {
    if (list.isEmpty) return null;
    return list.first;
  }

  print('  first: ${firstOrNull<int>([1, 2, 3])}');   // 1
  print('  first: ${firstOrNull<String>([])}');        // null

  // ========== 4. 泛型接口 ==========
  print('\n--- 4. 泛型接口 ---');
  // 🏛️ dart:core API — 泛型接口

  var cache = LocalCache<String>();
  cache.set('name', '小明');
  print('  取出: ${cache.get('name')}');

  // ========== 5. covariant 协变 ==========
  print('\n--- 5. covariant：放宽参数类型 ---');
  // 🏛️ dart:core API — covariant 关键字

  var dog = Dog();
  dog.feed(Dog());  // ✅ 传 Dog 可以
  // dog.feed(Cat());  // ❌ 运行时报错

  // ========== 6. 泛型与空安全 ==========
  print('\n--- 6. 泛型与空安全 ---');
  // 🏛️ dart:core API — T?

  T? toNullable<T>(T value) => value;
  String? result = toNullable<String>('hello');
  print('  toNullable: $result');

  // ========== 7. 运行时类型 ==========
  print('\n--- 7. 运行时类型 ---');
  // 🏛️ dart:core API — runtimeType

  void printType<T>(List<T> list) {
    print('  列表类型: ${list.runtimeType}');
  }

  printType<int>([1, 2, 3]);
  printType<String>(['a', 'b']);

  // ========== 8. 泛型建造者 ==========
  print('\n--- 8. 泛型建造者 ---');

  var query = QueryBuilder<Never>()  // Never = 不需要具体类型
    .where('age > 18')
    .orderBy('name')
    .limit(10)
    .build();

  print('  查询: $query');

  // ========== 9. 泛型类型别名 ==========
  print('\n--- 9. 泛型类型别名 ---');
  // 🏛️ dart:core API — typedef 泛型

  Transformer<String, int> stringLength = (s) => s.length;
  Predicate<int> isPositive = (n) => n > 0;

  print('  长度: ${stringLength('hello')}');  // 5
  print('  正数? ${isPositive(5)}');           // true

  print('\n程序结束');
}

/*
总结：泛型进阶

🏛️ dart:core API

1. 泛型约束：T extends num
   → T 只能是 num 或它的子类（int / double）

2. 多个参数：class Pair<K, V>
   → 两个不同类型

3. 泛型方法：T? firstOrNull<T>(List<T>)
   → 不依赖类的泛型

4. 泛型接口：abstract class Cache<T>
   → 实现类指定具体类型

5. covariant：子类重写时缩小参数类型
   → void feed(covariant Dog dog)

6. 空安全 T?：泛型也支持 null
   → String 传进去，String? 出来

7. runtimeType：运行时能看到完整泛型
   → List<int>、List<String>

8. 类型别名：typedef Transformer<T, R>
   → 给复杂的函数类型起名字

对比：第19课 vs 第70课

| 概念 | 第19课（基础） | 第70课（进阶） |
|------|---------------|---------------|
| 约束 | 无 | T extends num |
| 参数 | 1个 | 多个 |
| 场所 | 类上 | 类/方法/接口/别名 |
| covariant | ❌ | ✅ |
*/
