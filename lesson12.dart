// Dart 第十二课：空安全 null safety

void main() {
  // ? 表示这个变量可以为 null
  String? name = null;
  print(name); // null

  name = '小明';
  print(name); // 小明

  // ?? 如果左边为 null，用右边的值
  String? nickname;
  print(nickname ?? '默认昵称'); // 默认昵称

  // ?. 左边为 null 就不执行，返回 null
  String? user;
  user = '你好';
  print(user.length);   // 2（确定不为 null 时直接调）

  user = null;
  print(user?.length); // null（?. 安全调用，不崩溃）
}
