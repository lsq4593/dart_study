// Dart 第三十一课：late 延迟初始化

void main() {
  print('1. 创建对象');
  var report = Report();

  print('2. 处理其他事...');
  for (var i = 0; i < 3; i++) {
    print('   工作中...');
  }

  print('3. 第一次访问数据');
  print(report.data);
}

class Report {
  // late — 不创建时加载，用到才加载
  late String data = _loadBigData();

  String _loadBigData() {
    print('   [加载大量数据中...]');
    return '这是报告内容';
  }
}
