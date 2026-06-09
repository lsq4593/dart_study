// Dart 第五十七课：自定义异常

void main() {
  print('========== 自定义异常 ==========');

  // ========== 1. 基本自定义异常 ==========
  print('\n--- 1. 基本用法 ---');
  try {
    validateAge(-5);
  } on ValidationException catch (e) {
    print('  捕获: ${e}');
  }

  // ========== 2. 包含更多信息的异常 ==========
  print('\n--- 2. 多字段异常 ---');
  try {
    withdraw(100, 50);
  } on InsufficientBalanceException catch (e) {
    print('  错误: ${e.message}');
    print('  需要: ${e.required}元, 剩余: ${e.balance}元');
    print('  差额: ${e.shortfall}元');
  }

  // ========== 3. 多个 on 分支捕获不同类型 ==========
  print('\n--- 3. 多分支捕获 ---');

  void test(int code) {
    try {
      if (code == 1) throw NetworkException('连接超时', 408);
      if (code == 2) throw AuthException('token 过期', 401);
      if (code == 3) throw BusinessException('余额不足', 1001);
      print('  成功');
    } on NetworkException catch (e) {
      print('  网络错误: ${e.code} ${e.message}');
    } on AuthException catch (e) {
      print('  认证错误: ${e.code} ${e.message}');
    } on BusinessException catch (e) {
      print('  业务错误: ${e.code} ${e.message}');
    } on Exception catch (e) {
      print('  其他异常: $e');
    }
  }

  test(1);
  test(2);
  test(3);
  test(0);

  // ========== 4. rethrow 向上传递 ==========
  print('\n--- 4. rethrow 传递异常 ---');
  try {
    processData('bad data');
  } on FormatException catch (e) {
    print('  外层最终处理: $e');
  }

  // ========== 5. finally 清理资源 ==========
  print('\n--- 5. finally ---');
  try {
    print('  打开文件...');
    throw IOException('磁盘已满');
  } on IOException catch (e) {
    print('  IO错误: $e');
  } finally {
    print('  关闭文件... (无论如何都会执行)');
  }

  // ========== 6. 异常链 ==========
  print('\n--- 6. 异常链 ---');
  try {
    try {
      throw ValidationException('用户名为空', 'username');
    } on ValidationException catch (e) {
      // 包装成新的异常往外抛
      throw WrappedException('保存用户失败', e);
    }
  } on WrappedException catch (e) {
    print('  外层: ${e.message}');
    print('  内层: ${e.inner}');
  }

  // ========== 7. 实际场景：API 响应解析 ==========
  print('\n--- 7. 实际场景：API 响应 ---');

  String simulateApi(String jsonStr) {
    try {
      var data = jsonStr;
      if (data.isEmpty) throw ApiException('响应为空', -1);

      // 假设解析 JSON
      if (!data.contains('{')) throw ApiException('不是合法JSON', -2);

      if (data.contains('"code":500')) {
        throw ApiException('服务器内部错误', 500);
      }

      return '解析成功';
    } on ApiException catch (e) {
      return 'API错误: ${e.code} - ${e.message}';
    }
  }

  print('  ${simulateApi('{}')}');
  print('  ${simulateApi('{"code":500}')}');
  print('  ${simulateApi('')}');
  print('  ${simulateApi('not json')}');

  // ========== 8. Error vs Exception ==========
  print('\n--- 8. Error vs Exception ---');

  void demoError() {
    // 不该捕获 Error，应该修代码
    // try {
    //   var list = [1, 2, 3];
    //   print(list[100]);  // RangeError
    // } on Error catch (e) {
    //   print('捕获了Error: $e'); // 不应该这样做
    // }
  }

  print('  Error 代表程序 bug，不应该捕获');
  print('  Exception 代表可处理的异常');

  print('\n程序结束');
}

// ========== 1. 基本自定义异常 ==========
class ValidationException implements Exception {
  final String message;
  final String field;

  ValidationException(this.message, this.field);

  @override
  String toString() => '[$field] $message';
}

void validateAge(int age) {
  if (age < 0) {
    throw ValidationException('年龄不能为负数', 'age');
  }
  if (age > 150) {
    throw ValidationException('年龄不合法', 'age');
  }
}

// ========== 2. 多字段异常 ==========
class InsufficientBalanceException implements Exception {
  final String message;
  final double required;
  final double balance;

  InsufficientBalanceException(this.required, this.balance)
    : message = '余额不足',
      assert(required > balance);

  double get shortfall => required - balance;

  @override
  String toString() => '$message: 需要$required元, 剩余$balance元';
}

void withdraw(double amount, double balance) {
  if (amount > balance) {
    throw InsufficientBalanceException(amount, balance);
  }
}

// ========== 3. 多类型异常 ==========
class NetworkException implements Exception {
  final String message;
  final int code;
  NetworkException(this.message, this.code);
  @override
  String toString() => '[$code] $message';
}

class AuthException implements Exception {
  final String message;
  final int code;
  AuthException(this.message, this.code);
  @override
  String toString() => '[$code] $message';
}

class BusinessException implements Exception {
  final String message;
  final int code;
  BusinessException(this.message, this.code);
  @override
  String toString() => '[$code] $message';
}

// ========== 4. rethrow ==========
void processData(String data) {
  try {
    if (data == 'bad data') {
      throw FormatException('数据格式错误: $data');
    }
    print('  处理数据: $data');
  } on FormatException catch (e) {
    print('  内层: 记录日志后往上抛');
    rethrow;  // 往上传递，让外层处理
  }
}

// ========== 5. IO 异常 ==========
class IOException implements Exception {
  final String message;
  IOException(this.message);
  @override
  String toString() => 'IO异常: $message';
}

// ========== 6. 异常链 ==========
class WrappedException implements Exception {
  final String message;
  final Exception inner;
  WrappedException(this.message, this.inner);
  @override
  String toString() => '$message (原因: $inner)';
}

// ========== 7. API 异常 ==========
class ApiException implements Exception {
  final String message;
  final int code;
  ApiException(this.message, this.code);
  @override
  String toString() => '[$code] $message';
}

/*
总结：自定义异常

1. 定义异常
   class MyException implements Exception {
     final String message;
     MyException(this.message);
   }

2. 抛出
   throw MyException('描述');

3. 捕获
   try { ... }
   on MyException catch (e) { ... }
   on Exception catch (e) { ... }
   finally { ... }

4. rethrow
   内层记录日志后，把异常继续往上抛

5. Exception vs Error
   Exception → 可处理的错误（网络、校验、业务）
   Error → 程序 bug（越界、空指针），不该捕获，应该修代码

6. 注意
   - 用 implements Exception（不是 extends）
   - 重写 toString() 便于调试
   - 可以用多个字段承载更多上下文
*/
