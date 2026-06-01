// Dart 第二十四课：Extension 扩展方法

void main() {
  // 给 String 扩展的方法
  print('hello'.capitalize());
  print('hello dart'.capitalize());

  // 给 int 扩展的方法
  print(5.minutes);
  print(2.hours);
}

// extension 给已有类型加新方法
extension StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension IntExt on int {
  int get minutes => this * 60;
  int get hours => this * 3600;
}
