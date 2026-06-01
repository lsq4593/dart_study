// Dart 第四十二课：Switch 表达式（Dart 3）

void main() {
  var today = Weekday.wed;
  print(chineseName(today)); // 星期三

  var grade = switch (85) {
    >= 90 => '优秀',
    >= 60 => '及格',
    _ => '不及格',
  };
  print(grade); // 及格
}

enum Weekday { mon, tue, wed, thu, fri, sat, sun }

// switch 表达式直接返回值
String chineseName(Weekday d) => switch (d) {
  Weekday.mon => '星期一',
  Weekday.tue => '星期二',
  Weekday.wed => '星期三',
  Weekday.thu => '星期四',
  Weekday.fri => '星期五',
  Weekday.sat => '星期六',
  Weekday.sun => '星期日',
};

// 对比：旧式 switch 语句
String describeNumber(int n) {
  switch (n) {
    case > 0: return '正数';
    case 0: return '零';
    default: return '负数';
  }
}

// 新式 switch 表达式
String describeNumber2(int n) => switch (n) {
  > 0 => '正数',
  0 => '零',
  _ => '负数',
};

/*
对比：switch 语句 vs 表达式

| | 语句 | 表达式 |
|---|---|---|
| 返回值 | ❌ | ✅ |
| 穷尽性检查 | ❌ | ✅ 强制全覆盖 |
| break | 需要 | 不需要 |
*/
