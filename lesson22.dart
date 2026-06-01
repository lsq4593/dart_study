// Dart 第二十二课：Stream 流

void main() async {
  // Stream 就像水管，数据一段一段流过来
  await for (int n in countDown(3)) {
    print(n);
  }
  print('发射!');
}

// 每隔 1 秒发出一个数字
Stream<int> countDown(int from) async* {
  for (int i = from; i > 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // yield 像 return，但可以多次返回
  }
}
