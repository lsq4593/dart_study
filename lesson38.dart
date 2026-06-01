// Dart 第三十八课：copyWith 不可变更新

void main() {
  var user1 = User('小明', 25, '[email]xiaoming@test.com[/email]');
  var user2 = user1.copyWith(age: 26);

  print('${user1.name}, ${user1.age}'); // 小明, 25
  print('${user2.name}, ${user2.age}'); // 小明, 26（改了年龄）
  print(user1 == user2); // false（不同对象）
  print('${user1.name}, ${user1.email}'); // 姓名不变，邮箱不变
}

class User {
  final String name;
  final int age;
  final String email;

  const User(this.name, this.age, this.email);

  // copyWith：生成一个新对象，只修改指定的字段
  User copyWith({String? name, int? age, String? email}) {
    return User(
      name ?? this.name, // 没传就用原来的
      age ?? this.age,
      email ?? this.email,
    );
  }
}
