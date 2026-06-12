// Dart 全课程综合练习题 — 第4题
// 知识点：泛型类、泛型方法、泛型约束、泛型接口、typedef 泛型

// TODO:
// 1. 泛型接口 Repository<T> — 定义 save(T item)、T? findById(String id)、List<T> findAll()
// 2. 实现 InMemoryRepository<T> — 用 Map<String, T> 存储
// 3. 泛型方法：T? firstWhere<T>(List<T> items, bool Function(T) test) — 找到第一个满足条件的
// 4. 泛型约束：double average<T extends num>(List<T> items) — 计算平均值
// 5. typedef 定义 Filter<T> = bool Function(T)
// 6. 用 Repository<User> 存储用户，用 filter 筛选

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
