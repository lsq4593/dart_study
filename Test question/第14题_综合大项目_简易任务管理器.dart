// Dart 全课程综合练习题 — 第14题
// 知识点：综合运用全部知识点 — 简易任务管理器

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:collection';

/*
需求：
1. Task 类（id, title, status枚举, priority枚举, createdAt, completedAt）
   - status: todo, doing, done, cancelled
   - priority: low, medium, high, urgent
   - 支持 copyWith
   - toJson / fromJson
2. TaskManager 类
   - 用 List<Task> 存储
   - 增删改查
   - 按状态/优先级过滤
   - 排序（按优先级、按创建时间）
   - 统计（总数、各状态数量）
3. 持久化
   - 保存到 JSON 文件
   - 启动时读取
4. 异步通知
   - 用 Stream 广播任务变化事件
   - 用 Completer 实现"等待某个任务完成"
5. 错误处理
   - 自定义 TaskException
   - Zone 包裹防止崩溃
6. 其他
   - 用 StringBuffer 生成报表
   - 用 extension 给 Task 加格式化输出
   - 用 typedef 定义 Filter 类型
*/

// TODO: 定义枚举 TaskStatus 和 TaskPriority
// TODO: 定义 Task 类
// TODO: 定义 TaskManager 类
// TODO: 自定义 TaskException
// TODO: extension on Task
// TODO: typedef Filter<T>

void main() async {
  // 测试你的任务管理器
  var manager = TaskManager();
  
  // 添加任务
  manager.addTask(Task(id: '1', title: '学习Dart', priority: TaskPriority.high));
  manager.addTask(Task(id: '2', title: '写Flutter项目', priority: TaskPriority.medium));
  manager.addTask(Task(id: '3', title: '休息', priority: TaskPriority.low));
  
  // 监听变化
  manager.onChange.listen((event) => print('任务变更: $event'));
  
  // 过滤
  print('高优先级: ${manager.filterByStatus(TaskStatus.todo)}');
  
  // 等待某个任务完成
  manager.waitForComplete('1').then((_) => print('任务1已完成!'));
  manager.completeTask('1');
  
  // 生成报表
  print(manager.generateReport());
}
