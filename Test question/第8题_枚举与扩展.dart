// Dart 全课程综合练习题 — 第8题
// 知识点：增强枚举、Extension方法、extension type

// TODO:
// 1. 增强枚举 HttpStatus
//    - code: int
//    - message: String
//    - getter isSuccess: code 在 200-299 之间
//    - 方法：bool isRetryable() — 500+ 可重试，其他不可

// 2. 给 String 加扩展方法
//    - bool get isValidEmail — 用正则校验邮箱
//    - String get maskPhone — 隐藏手机号中间四位（如 138****5678）
//    - int? get toInt — 安全转整数，转换失败返回 null

// 3. extension type 包装 Email
//    - Email(String value) — 内部校验是否包含 @
//    - isValid getter
//    - 对外不暴露原始 value

void main() {
  // 测试枚举
  print('200: ${HttpStatus.ok.isSuccess}, 可重试? ${HttpStatus.ok.isRetryable()}');
  print('500: ${HttpStatus.internalServerError.isSuccess}, 可重试? ${HttpStatus.internalServerError.isRetryable()}');
  
  // 测试扩展方法
  print('"test@example.com" 是合法邮箱? ${'test@example.com'.isValidEmail}');
  print('"abc" 是合法邮箱? ${'abc'.isValidEmail}');
  print('隐藏手机号: ${'13812345678'.maskPhone}');
  print('"42" 转整数: ${'42'.toInt}');
  print('"abc" 转整数: ${'abc'.toInt}');
  
  // 测试 extension type
  var email = Email('user@example.com');
  print('Email 合法? ${email.isValid}');
  // print(email.value); // ❌ 不能访问
}
