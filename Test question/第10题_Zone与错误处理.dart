// Dart 全课程综合练习题 — 第10题
// 知识点：Zone、runZonedGuarded、ZoneSpecification、自定义异常、try-catch

import 'dart:async';

// TODO:
// 1. 自定义异常类 AppException（含 code 和 message）
// 2. 写一个函数 fetchData(bool shouldFail) 可能会抛 AppException
// 3. 用 runZoned 包裹，要求：
//    - zoneValues 传递 requestId
//    - ZoneSpecification 拦截 print，添加时间前缀
//    - onError 捕获异步错误不崩程序
// 4. Zone 外抛一个普通异常，看是否被隔离

class AppException implements Exception {
  // TODO: code (int), message (String)
  // 实现 toString()
}

Future<String> fetchData(bool shouldFail) async {
  await Future.delayed(Duration(milliseconds: 200));
  if (shouldFail) throw AppException(500, '服务器内部错误');
  return '数据加载成功';
}

void main() {
  print('=== 程序开始 ===');
  
  // TODO: 用 runZoned 包裹
  // - zoneValues: {'requestId': 'REQ-001'}
  // - ZoneSpecification: 拦截 print 加时间前缀 "[HH:mm:ss]"
  // - onError: 捕获异步错误
  
  runZoned(
    () {
      print('发送请求...');
      fetchData(false).then(print);
      fetchData(true).then(print).catchError((e) {
        print('错误被捕获: $e');
      });
      
      // 抛一个同步错误
      // throw Exception('同步错误');
    },
    // TODO: zoneValues
    // TODO: zoneSpecification
    // TODO: onError
  );
  
  // Zone 外的代码不受影响
  print('=== 程序结束 ===');
  
  // 保持程序运行直到异步完成
  // 注意：实际运行可能需要 await Future.delayed 或使用 runZonedGuarded
}
