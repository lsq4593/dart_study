// Dart 练习题 — 第1题 拓展②：猜数字游戏
// 知识点：变量、Random、循环、条件判断、字符串插值、函数
//
// 实现一个猜数字游戏，电脑随机生成一个数字，玩家猜，直到猜中为止。

import 'dart:developer';
import 'dart:math';

import '../lesson57.dart';

void main() {
  print('========== 猜数字游戏 ==========\n');
  print('电脑已生成一个 1~100 之间的数字，请开始猜！\n');

  // ====== 第1步：生成随机数 ======
  // 用 Random().nextInt(100) + 1 生成 1~100 的随机整数

  // TODO: 生成随机数
  Random random = Random();
  int target = 0; // 替换这行

  // ====== 第2步：猜数字主循环 ======
  // 用 for 循环遍历 mockGuesses，每次猜一个数字
  // 如果猜大了打印"猜大了"，猜小了打印"猜小了"
  // 猜中了打印"恭喜！"并记录猜中状态
  // 用 guessCount 记录猜测次数

  // TODO: 实现猜数字循环
  int guessCount = 0;
  bool isGuessed = false;

  // 模拟玩家猜测序列
  List<int> mockGuesses = [50, 75, 63, 68, 66, 67];

  for (int g in mockGuesses) {
    if (isGuessed) break;

    guessCount++;
    if (g > target) {
      print('第${guessCount}次猜 $g → 猜大了');
    } else if (g < target) {
      print('第${guessCount}次猜 $g → 猜小了');
    } else {
      print('第${guessCount}次猜 $g → 🎉 猜中了！');
      isGuessed = true;
    }
    // 在此判断猜大猜小
  }

  // ====== 第3步：统计结果 ======
  // 如果猜中了，打印用了多少次
  // 如果没猜中，打印正确答案
  // 用条件判断给出评价（<=3次天才，<=5次不错，>5次继续加油）

  // TODO: 打印结果
  if (isGuessed) {
    print('\n你用了 $guessCount 次猜中了答案！');
    // 在此输出评价
  } else {
    print('\n没猜中，正确答案是 $target');
  }

  // ====== 第4步：猜数字范围分析 ======
  // 每次猜测后，根据猜大猜小更新可能范围 [minRange, maxRange]

  // TODO: 实现范围分析
  int minRange = 1, maxRange = 100;
  print('\n--- 范围分析 ---');

  // 遍历已猜的数字，更新范围并打印

  // ====== 第5步：计算理论最优次数 ======
  // 二分查找法：1~100 最多需要猜几次？
  // 用 while 循环计算：每次排除一半，直到范围缩小到 1

  // TODO: 计算二分查找的最多猜测次数
  int binaryCount = 0;
  int range = 100;
  while (range > 1) {
    range = (range + 1) ~/ 2;
    binaryCount++;
  }
  print('\n理论最少需要 $binaryCount 次（二分查找法）');

  print('\n========== 游戏结束 ==========');
}
