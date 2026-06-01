// Dart 第四十课：extension type 扩展类型

void main() {
  // 用扩展类型包装后，只能通过定义的方法操作
  var valid = Email('[email]test@example.com[/email]');
  valid.send(); // ✅
  // valid.value = 'abc';  // ❌ 不能直接访问原始值
}

// extension type：对已有类型包一层，限制外部访问
extension type Email(String value) {
  // 可以在这里加自己的方法
  bool get isValid => value.contains('@');

  void send() {
    if (!isValid) {
      print('邮箱格式不对');
      return;
    }
    print('发送邮件到 $value');
  }
}
