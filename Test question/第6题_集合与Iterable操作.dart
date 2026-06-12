// Dart 全课程综合练习题 — 第6题
// 知识点：List、Set、Map、Iterable方法（where/map/reduce/fold/any/every/take/skip）、Queue

import 'dart:collection';

void main() {
  var words = ['hello', 'world', 'dart', 'flutter', 'hi', 'code', 'programming'];
  var numbers = [5, 12, 8, 3, 15, 7, 22, 9, 1, 18];
  
  // TODO: 用链式调用实现以下功能
  
  // 1. 从 words 中过滤出长度 >= 4 的单词，转成大写，取前 3 个
  var result1 = words
      // ... 链式调用
      ;
  print('#1: $result1'); // 期望: [HELLO, WORLD, DART]
  
  // 2. 用 reduce 计算 numbers 的乘积
  var product = numbers.
      // ...
      ;
  print('#2: $product'); // 期望: 一个很大的数
  
  // 3. 用 fold 把 numbers 中所有偶数拼接成字符串用逗号分隔
  var evenStr = numbers.
      // ...
      ;
  print('#3: $evenStr'); // 期望: "12,8,22,18"
  
  // 4. 检查 words 中是否所有单词都包含字母 'e'
  var allHaveE = words.
      // ...
      ;
  print('#4: $allHaveE');
  
  // 5. 用 Set 找出两个数组的交集和并集
  var a = [1, 2, 3, 4, 5, 6];
  var b = [4, 5, 6, 7, 8, 9];
  var intersection = // ...
  var union = // ...
  print('#5: 交集=$intersection, 并集=$union');
  
  // 6. 用 Queue 模拟一个消息队列：先进先出，依次处理
  var queue = Queue<String>();
  queue.addAll(['msg1', 'msg2', 'msg3', 'msg4']);
  // TODO: 依次取出并打印，每次取一个
  // while (queue.isNotEmpty) { ... }
}
