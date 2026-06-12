// Dart 全课程综合练习题 — 第9题
// 知识点：JSON编解码、文件读写、目录操作、DateTime、RegExp

import 'dart:convert';
import 'dart:io';

// TODO:
// 1. 定义一个 Note 类（id, title, content, createdAt）
//    实现 toJson() 和 fromJson()
// 2. 写一个 NoteManager 类
//    - 将 Note 列表保存到 JSON 文件
//    - 从 JSON 文件读取 Note 列表
//    - 可以添加、删除、按标题搜索 Note
//    - 搜索支持正则表达式
// 3. 创建测试目录 test_notes，在里面操作文件
// 4. 统计所有 Note 的创建时间（按月统计数量）

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  
  Note({required this.id, required this.title, required this.content, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
  
  // TODO: toJson() 方法
  // TODO: fromJson() 工厂构造函数
}

class NoteManager {
  final String dirPath;
  
  NoteManager(this.dirPath);
  
  // TODO: 
  // - Future<void> saveNotes(List<Note> notes)
  // - Future<List<Note>> loadNotes()
  // - Future<void> addNote(Note note)
  // - Future<void> deleteNote(String id)
  // - Future<List<Note>> searchByTitle(String pattern) // 支持正则
  // - Future<Map<int, int>> countByMonth() // 按月统计
}

void main() async {
  var manager = NoteManager('${Directory.current.path}/test_notes');
  
  // 添加测试笔记
  await manager.addNote(Note(id: '1', title: 'Dart学习笔记', content: '今天学习了Stream'));
  await manager.addNote(Note(id: '2', title: 'Flutter入门', content: 'Widget树'));
  await manager.addNote(Note(id: '3', title: 'Dart异步编程', content: 'async/await'));
  
  // 搜索含"Dart"的笔记
  var results = await manager.searchByTitle('Dart');
  print('搜索"Dart"结果: ${results.length} 条');
  
  // 按月统计
  var stats = await manager.countByMonth();
  print('按月统计: $stats');
  
  // 删除笔记
  await manager.deleteNote('2');
  print('删除后共 ${(await manager.loadNotes()).length} 条');
}
