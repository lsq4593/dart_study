// Dart 第二十六课：sealed class 密封类

void main() {
  check(Success('数据加载完成'));
  check(Loading());
  check(Error('网络错误'));
}

sealed class Result {} // 密封类：所有子类都在这

class Success extends Result {
  final String data;
  Success(this.data);
}

class Loading extends Result {}

class Error extends Result {
  final String message;
  Error(this.message);
}

void check(Result r) {
  // switch 必须覆盖所有子类，漏一个编译报错
  switch (r) {
    case Success(:var data):
      print('成功: $data');
    case Loading():
      print('加载中...');
    case Error(:var message):
      print('失败: $message');
  }
}
