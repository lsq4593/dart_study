// Dart 全课程综合练习题 — 第3题
// 知识点：空安全、late、??、?.、assert

class User {
  final String name;
  final int? age;       // 年龄可以为 null
  final String? email;  // 邮箱可以为 null
  late final String userInfo; // late 延迟初始化

  // TODO: 
  // 1. 构造函数：name 必填，age 和 email 可选可为 null
  // 2. 实现一个 getter 'displayAge'：age 不为 null 返回 "$age 岁"，否则返回 "年龄未知"
  // 3. 实现一个 getter 'displayEmail'：email 不为 null 返回 email，否则返回 "未设置邮箱"
  // 4. 在构造函数中初始化 userInfo，格式为 "用户: name (displayAge)"
  // 5. 添加一个方法 validate()：用 assert 检查 name 不能为空字符串
}

void main() {
  // 测试各种情况，包括 null
  var user1 = User('小明', age: 25, email: 'xiaoming@test.com');
  var user2 = User('小红', age: null);
  var user3 = User('小刚', email: 'xiaogang@test.com');
  var user4 = User('');
  
  // 打印所有用户信息
  // 测试 user4.validate() 触发断言（需在 debug 模式运行）
}
