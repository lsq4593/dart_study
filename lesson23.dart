// Dart 第二十三课：异常处理 try / catch

void main() async {
  try {
    var data = await fetchData(false);
    print(data);
  } catch (e) {
    print('出错了: $e');
  }
  print('程序继续运行');
}

Future<String> fetchData(bool success) async {
  await Future.delayed(Duration(seconds: 1));
  if (!success) {
    throw Exception('网络错误');
  }
  return '数据加载成功';
}
