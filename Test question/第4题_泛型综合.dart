// Dart 全课程综合练习题 — 第4题
// 知识点：泛型类、泛型方法、泛型约束、泛型接口、typedef 泛型

// 1. 泛型接口 Repository<T>
// abstract class：抽象类充当"接口"，只声明方法，不提供实现，子类必须全部实现
// <T>：类型参数，调用时指定具体类型，如 Repository<User>、Repository<String>
abstract class Repository<T> {
  // 保存一条 T 类型的数据
  void save(T item);

  // 按 id 查找，找不到时返回 null（所以返回类型是 T?）
  T? findById(String id);

  // 返回所有 T 类型数据的列表
  List<T> findAll();
}

// 2. 实现 InMemoryRepository<T> — 用 Map<String, T> 存储
// implements Repository<T>：实现上面定义的泛型接口
// _store：Map 的 key 是 id（String），value 是 T 类型对象
class InMemoryRepository<T> implements Repository<T> {
  final Map<String, T> _store = {};

  @override
  void save(T item) {
    // 从 item 中取出 id 作为 Map 的 key（User 有 id 字段）
    final id = (item as dynamic).id as String;
    _store[id] = item;
  }

  @override
  T? findById(String id) => _store[id];

  @override
  List<T> findAll() => _store.values.toList();
}

// 3. 泛型方法 firstWhere — 遍历列表，返回第一个满足 test 条件的元素
T? firstWhere<T>(List<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

// 4. 泛型约束 average — T extends num 表示 T 必须是 num 的子类型（int、double 等）
double average<T extends num>(List<T> items) {
  if (items.isEmpty) return 0;
  return items.fold<double>(0, (sum, item) => sum + item.toDouble()) / items.length;
}

// 5. typedef Filter — 给函数类型起别名，Filter<User> 等价于 bool Function(User)
typedef Filter<T> = bool Function(T);

class User {
  final String id;
  final String name;
  final int age;
  User(this.id, this.name, this.age);
  
  @override
  String toString() => 'User($id, $name, $age)';
}

void main() {
  // 测试代码
  var repo = InMemoryRepository<User>();
  repo.save(User('1', '小明', 25));
  repo.save(User('2', '小红', 17));
  repo.save(User('3', '小刚', 30));
  
  print('所有用户: ${repo.findAll()}');
  print('查找 id=2: ${repo.findById('2')}');
  
  // 用泛型方法 firstWhere
  var user = firstWhere<User>(repo.findAll(), (u) => u.age >= 18);
  print('第一个成年人: $user');
  
  // 用泛型约束计算平均年龄
  var ages = repo.findAll().map((u) => u.age).toList();
  print('平均年龄: ${average<int>(ages)}');
  
  // 用 typedef Filter
  Filter<User> adultFilter = (u) => u.age >= 18;
  var adults = repo.findAll().where(adultFilter).toList();
  print('成年人: $adults');
}
