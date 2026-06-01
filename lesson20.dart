// Dart 第二十课：枚举 enum

void main() {
  var today = Weekday.wed;

  // switch 配合枚举，必须处理所有情况
  switch (today) {
    case Weekday.sat:
    case Weekday.sun:
      print('休息日');
      break;
    default:
      print('工作日');
  }

  print(today.name);    // 名称: wed
  print(today.index);   // 索引: 2（从0开始）
}

enum Weekday { mon, tue, wed, thu, fri, sat, sun }
