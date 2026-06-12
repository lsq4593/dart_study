// Dart 全课程综合练习题 — 第11题
// 知识点：DateTime、Timer、Duration、Stream.periodic

import 'dart:async';

// TODO: 实现以下功能

// 1. 创建一个 Reminder 类，包含 title、DateTime remindTime
// 2. 给 Reminder 加扩展方法：
//    - Duration get timeLeft — 距离提醒还剩多少时间（如果已过时返回负值）
//    - bool get isExpired — 是否已过期
// 3. 创建一个 Schedule 类管理多个 Reminder
//    - 可以添加、取消提醒
//    - 用 Timer 在指定时间触发提醒
//    - 用 Stream 广播提醒事件
// 4. 写一个函数 printTimeLeft(DateTime target)，每秒打印一次剩余时间

class Reminder {
  final String title;
  final DateTime remindTime;
  
  Reminder(this.title, this.remindTime);
}

// TODO: Extension on Reminder
// extension ReminderExt on Reminder { ... }

class Schedule {
  final _reminders = <Reminder>[];
  final _controller = StreamController<Reminder>.broadcast();
  
  Stream<Reminder> get onReminder => _controller.stream;
  
  // TODO: 添加提醒（用 Timer 在指定时间触发）
  void addReminder(Reminder r) {
    // ...
  }
  
  // TODO: 取消提醒
  void cancelReminder(Reminder r) {
    // ...
  }
  
  void dispose() {
    _controller.close();
  }
}

// TODO: 每秒打印一次剩余时间
void printTimeLeft(DateTime target) {
  // ...
}

void main() async {
  var schedule = Schedule();
  
  schedule.onReminder.listen((r) => print('⏰ 提醒: ${r.title}'));
  
  // 添加 3 秒后的提醒
  schedule.addReminder(Reminder('休息一下', DateTime.now().add(Duration(seconds: 3))));
  
  // 打印剩余时间
  printTimeLeft(DateTime.now().add(Duration(seconds: 5)));
  
  await Future.delayed(Duration(seconds: 6));
  schedule.dispose();
}
