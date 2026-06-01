// Dart 第二十八课：factory 工厂构造函数

void main() {
  // 普通构造函数 — 每次都创建新对象
  var p1 = Person('小明');
  var p2 = Person('小明');
  print('普通: ${p1 == p2}'); // false，不同对象

  // 工厂构造函数 — 可能返回已有对象
  var c1 = Config('127.0.0.1');
  var c2 = Config('127.0.0.1');
  print('工厂: ${c1 == c2}'); // true，同一个对象
}

class Person {
  String name;
  Person(this.name);
}

class Config {
  static final _cache = <String, Config>{};
  String host;

  // factory 可以决定返回新对象还是已有对象
  factory Config(String host) {
    if (_cache.containsKey(host)) {
      return _cache[host]!;
    }
    var config = Config._internal(host);
    _cache[host] = config;
    return config;
  }

  // 私有构造函数，只有 factory 能调
  Config._internal(this.host);
}
