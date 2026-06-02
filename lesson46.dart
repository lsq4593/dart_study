// Dart 第四十六课：DateTime 日期时间处理

void main() {
  // ========== 1. 创建 DateTime 对象 ==========

  // 当前时间（本地时区）
  var now = DateTime.now();
  print('当前时间: $now'); // 2026-06-02 18:30:00.123 (示例)

  // 指定日期（年、月、日）
  var date1 = DateTime(2026, 6, 2);
  print(date1); // 2026-06-02 00:00:00.000

  // 指定日期时间（年、月、日、时、分、秒、毫秒）
  var date2 = DateTime(2026, 6, 2, 14, 30, 0);
  print(date2); // 2026-06-02 14:30:00.000

  // 从字符串解析（ISO 8601 格式）
  var date3 = DateTime.parse('2026-06-05');
  print(date3); // 2026-06-02 14:30:00.000

  // 从 Unix 时间戳创建（毫秒）
  var date4 = DateTime.fromMillisecondsSinceEpoch(1717200000000);
  print(date4); // 对应 2026-06-01 左右

  // UTC 时间
  var utcNow = DateTime.now().toUtc();
  print('UTC 时间: $utcNow');

  // ========== 2. 获取日期时间的各个部分 ==========
  var dt = DateTime(2026, 6, 2, 14, 30, 45, 123);

  print('年: ${dt.year}'); // 2026
  print('月: ${dt.month}'); // 6
  print('日: ${dt.day}'); // 2
  print('时: ${dt.hour}'); // 14
  print('分: ${dt.minute}'); // 30
  print('秒: ${dt.second}'); // 45
  print('毫秒: ${dt.millisecond}'); // 123
  print('微秒: ${dt.microsecond}'); // 0

  print('星期几: ${dt.weekday}'); // 2 (周一=1, 周日=7)
  // ⚠️ dt.dayOfYear 不存在！Dart 没有这个属性，需自己计算
  // 计算年中第几天：1月1日=第1天
  var startOfYear = DateTime(dt.year, 1, 1);
  var daysPassed = dt.difference(startOfYear).inDays + 1;
  print('年中第几天: $daysPassed');

  // 判断是上午还是下午
  print('${dt.hour < 12 ? "上午" : "下午"}');

  // ========== 3. 日期计算：加和减 ==========
  var today = DateTime(2026, 6, 2);

  // 加天数
  var future = today.add(Duration(days: 7));
  print('一周后: $future'); // 2026-06-09

  // 减天数
  var past = today.subtract(Duration(days: 3));
  print('三天前: $past'); // 2026-05-30

  // 加小时、分钟
  var later = today.add(Duration(hours: 5, minutes: 30));
  print('5小时30分钟后: $later');

  // ⚠️ Duration 的月份加减陷阱
  // Duration 没有 months 参数！因为每月天数不同
  // 加月份要用「构造函数重新创建」
  var nextMonth = DateTime(today.year, today.month + 1, today.day);
  print('下个月同一天: $nextMonth'); // 2026-07-02

  // 如果下个月没有这一天（比如 1月31日 → 2月31日不存在）
  // Dart 会自动进到下下个月：2月31日 → 3月3日
  var jan31 = DateTime(2026, 1, 31);
  var febIssue = DateTime(jan31.year, jan31.month + 1, jan31.day);
  print('1月31日加1个月: $febIssue'); // 2026-03-03（2月只有28天，自动进位）

  // ========== 4. 日期比较 ==========
  var a = DateTime(2026, 6, 2);
  var b = DateTime(2026, 6, 5);

  print(a.isBefore(b)); // true  — a 在 b 之前
  print(a.isAfter(b)); // false — a 在 b 之后
  print(a.isAtSameMomentAs(b)); // false — 是否是同一时刻

  // 比较是否同一天（不能用 ==，因为时间可能不同）
  var c = DateTime(2026, 6, 2, 8, 0); // 早上8点
  var d = DateTime(2026, 6, 2, 20, 0); // 晚上8点
  print(c == d); // false — 时间不同！
  print(isSameDay(c, d)); // true  — 同一天

  // 计算两个日期的差值
  var diff = b.difference(a);
  print('相差: ${diff.inDays} 天'); // 3 天
  print('相差: ${diff.inHours} 小时'); // 72 小时
  print('相差: ${diff.inMinutes} 分钟'); // 4320 分钟

  // ========== 5. 格式化日期时间 ==========
  // Dart 没有内置的日期格式化方法（不像 Java 的 SimpleDateFormat）
  // 但可以自己拼字符串

  print('${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}'); // 2026-06-02
  print('${_pad(dt.hour)}:${_pad(dt.minute)}:${_pad(dt.second)}'); // 14:30:45

  var weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  print('${dt.year}年${dt.month}月${dt.day}日 ${weekdays[dt.weekday - 1]}');
  // 2026年6月2日 周二

  // ========== 6. 常用工具函数 ==========

  // 判断闰年
  print('2026年是闰年? ${isLeapYear(2026)}'); // false
  print('2024年是闰年? ${isLeapYear(2024)}'); // true

  // 获取某月的天数
  print('2026年2月有${daysInMonth(2026, 2)}天'); // 28
  print('2024年2月有${daysInMonth(2024, 2)}天'); // 29

  // 获取本周的开始日期（周一）
  var weekStart = getWeekStart(today);
  print('本周一: $weekStart');

  // 获取本月的第一天和最后一天
  var monthStart = DateTime(today.year, today.month, 1);
  var monthEnd = DateTime(today.year, today.month + 1, 0);
  print('本月第一天: $monthStart');
  print('本月最后一天: $monthEnd');

  // ========== 7. 时间戳（Unix 时间戳） ==========
  var timestamp = DateTime.now().millisecondsSinceEpoch;
  print('当前时间戳(毫秒): $timestamp');

  // 秒级时间戳（除以1000取整）
  var seconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  print('当前时间戳(秒): $seconds');

  // 从时间戳恢复日期
  var fromTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
  print('从时间戳恢复: $fromTimestamp');

  // ========== 8. 解析不同格式的日期字符串 ==========
  // Dart 的 parse 只认 ISO 8601 格式：
  //   "2026-06-02"
  //   "2026-06-02 14:30:00"
  //   "2026-06-02T14:30:00.000"
  //   "2026-06-02T14:30:00Z"（UTC）

  // 遇到其他格式（如 "2026/06/02" 或 "06-02-2026"），要先替换
  var str1 = '2026/06/02'.replaceAll('/', '-');
  print(DateTime.parse(str1)); // 2026-06-02 00:00:00.000

  var str2 = '06-02-2026';
  var parts = str2.split('-');
  var parsed2 = DateTime(
    int.parse(parts[2]),
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
  print(parsed2); // 2026-06-02
}

// ========== 辅助函数 ==========

/// 判断两个 DateTime 是否是同一天
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// 判断是否为闰年
/// 规则：能被4整除但不能被100整除，或者能被400整除
bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

/// 获取某月的天数
int daysInMonth(int year, int month) {
  // 下个月的第0天 = 这个月的最后一天
  return DateTime(year, month + 1, 0).day;
}

/// 获取本周一的日期
DateTime getWeekStart(DateTime date) {
  // weekday: 周一=1, 周日=7
  // 如果是周一(1)，减0天；周二(2)，减1天...周日(7)，减6天
  return date.subtract(Duration(days: date.weekday - 1));
}

/// 数字补零（1 → "01"）
String _pad(int n) => n.toString().padLeft(2, '0');

/*
总结：DateTime 核心操作

1. 创建
   DateTime.now()                    — 当前时间
   DateTime(2026, 6, 2)             — 指定日期
   DateTime.parse('2026-06-02')     — 解析字符串
   DateTime.fromMillisecondsSinceEpoch(ts) — 从时间戳

2. 读取
   .year .month .day .hour .minute .second
   .weekday (1=周一, 7=周日)
   .millisecondsSinceEpoch

3. 计算
   .add(Duration(days: n))          — 加天数
   .subtract(Duration(days: n))     — 减天数
   .difference(other) → Duration    — 差值
   DateTime(year, month+1, day)     — 加月份（注意进位问题）

4. 比较
   .isBefore(other)  .isAfter(other)  .isAtSameMomentAs(other)

5. 注意点
   - Duration 没有 months 参数，加减月份要用构造函数
   - == 比较的是时刻，不是同一天；判断同一天要比较 year+month+day
   - parse 只认 ISO 8601 格式，其他格式需手动转换

常用场景：
   - 显示当前时间
   - 计算倒计时 / 剩余天数
   - 判断是否同一天
   - 获取周、月、年的开始和结束
   - 时间戳转换
*/
