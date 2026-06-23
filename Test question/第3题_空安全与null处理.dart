// Dart 全课程综合练习题 — 第3题
// 知识点：空安全、late、??、?.、assert

class User {
  final String name;
  final int? age;       // 年龄可以为 null
  final String? email;  // 邮箱可以为 null
  late final String userInfo; // late 延迟初始化

  User(this.name, {this.age, this.email}) {
    // 4. 在构造函数中初始化 userInfo，格式为 "用户: name (displayAge)"
    userInfo = '用户: $name ($displayAge)';
  }

  String get displayAge => age != null ? '$age 岁' : '年龄未知';

  // 3. 实现一个 getter 'displayEmail'：email 不为 null 返回 email，否则返回 "未设置邮箱"
  String get displayEmail => email ?? '未设置邮箱';

  // 5. 添加一个方法 validate()：用 assert 检查 name 不能为空字符串
  void validate() {
    assert(name.isNotEmpty, 'name 不能为空字符串');
  }
}

void main() {
  // 测试各种情况，包括 null
  var user1 = User('小明', age: 25, email: 'xiaoming@test.com');
  var user2 = User('小红', age: null);
  var user3 = User('小刚', email: 'xiaogang@test.com');
  var user4 = User('');

  // 打印所有用户信息
  print('${user1.userInfo} | 邮箱: ${user1.displayEmail}');
  print('${user2.userInfo} | 邮箱: ${user2.displayEmail}');
  print('${user3.userInfo} | 邮箱: ${user3.displayEmail}');

  // 测试 user4.validate() 触发断言（需在 debug 模式运行）
  // 取消下面注释以测试断言（需 dart run --enable-asserts 运行）
  // user4.validate();
}
