// Dart 第三十七课：import 导入

// 导入同一项目中的其他文件
import 'math.dart';

// dart:core 自动导入，不需要写
// import 'dart:core'; // 多余，print、int、String 都在这里面

// 导入 dart 标准库
import 'dart:math';

void main() {
  print(add(10, 5));    // 从 math.dart 导入
  print(subtract(10, 5));

  // dart:math 里的
  print(pi);            // 3.1415926...
  print(sqrt(16));      // 4.0
}
