// Dart 第二十一课：异步 async / await

void main() async {
  print('开始');
  String data = await fetchData();
  print(data);
  print('结束');
}

// 模拟网络请求
Future<String> fetchData() async {
  // Future 表示"未来的值"，await 等它完成
  await Future.delayed(Duration(seconds: 2));
  return '数据加载完成';
}
