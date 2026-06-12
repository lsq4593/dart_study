// Dart 全课程综合练习题 — 第12题
// 知识点：base/interface/final/sealed、copyWith、getter/setter、static、factory

// TODO: 设计一个不可变（immutable）配置系统

// 1. final class AppConfig — 禁止继承和实现
//    - 字段：String apiUrl, int timeout, bool enableLogging
//    - 全部 final，通过构造函数传入
//    - 实现 copyWith 方法
//    - 提供 static 默认配置 AppConfig.defaultConfig

// 2. base class BaseService — 只能继承不能实现
//    - 包含 AppConfig 实例
//    - 抽象方法 Future<T> request<T>(String path)

// 3. sealed class ApiResult<T> — 密封结果类型
//    - Success(T data) 和 Failure(String message, int code)
//    - 用 switch 表达式处理结果

void main() {
  // 测试
  var config = AppConfig.defaultConfig;
  print('默认配置: ${config.apiUrl}, timeout=${config.timeout}');
  
  var newConfig = config.copyWith(apiUrl: 'https://api.example.com');
  print('新配置: ${newConfig.apiUrl}');
  
  var result1 = ApiResult<String>.success('数据加载成功');
  var result2 = ApiResult<int>.failure('网络错误', 404);
  
  for (var r in [result1, result2]) {
    switch (r) {
      case Success<String>(data: var d):
        print('成功: $d');
      case Failure<int>(message: var msg):
        print('失败: $msg');
      default:
        print('未知');
    }
  }
}
