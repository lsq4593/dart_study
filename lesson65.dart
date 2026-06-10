// Dart 第六十五课：dart:math 数学库

import 'dart:math';

void main() {
  print('========== dart:math ==========');

  // ========== 1. 常量 pi / e ==========
  print('\n--- 1. 数学常量 ---');
  print('  π = $pi');
  print('  e = $e');
  print('  π 保留2位: ${pi.toStringAsFixed(2)}');

  // ========== 2. 最值 max / min ==========
  print('\n--- 2. max / min ---');
  print('  max(3, 7) = ${max(3, 7)}');    // 7
  print('  min(3, 7) = ${min(3, 7)}');    // 3
  print('  数组最大值: ${[3, 7, 2, 9, 5].reduce(max)}'); // 9

  // ========== 3. 幂运算 pow ==========
  print('\n--- 3. pow 幂运算 ---');
  print('  2^10 = ${pow(2, 10)}');            // 1024.0
  print('  2^10 取整 = ${pow(2, 10).toInt()}'); // 1024
  print('  9^0.5 (平方根) = ${pow(9, 0.5)}');   // 3.0
  print('  10^3 = ${pow(10, 3).toInt()}');     // 1000

  // ========== 4. 平方根 sqrt ==========
  print('\n--- 4. sqrt 平方根 ---');
  print('  sqrt(16) = ${sqrt(16)}');       // 4.0
  print('  sqrt(2)  = ${sqrt(2).toStringAsFixed(4)}'); // 1.4142

  // ========== 5. Random 随机数 ==========
  print('\n--- 5. Random 随机数 ---');

  // 默认随机种子
  var rng = Random();
  print('  随机 0-99: ${rng.nextInt(100)}');    // 0..99
  print('  随机小数: ${rng.nextDouble()}');     // 0.0..1.0
  print('  随机 bool: ${rng.nextBool()}');      // true/false

  // 固定种子（可复现）
  var fixed = Random(42);
  print('  固定种子第1次: ${fixed.nextInt(100)}'); // 每次运行都一样
  print('  固定种子第2次: ${fixed.nextInt(100)}');

  // 实用：随机选取
  var fruits = ['苹果', '香蕉', '西瓜', '葡萄', '橘子'];
  var pick = fruits[rng.nextInt(fruits.length)];
  print('  随机水果: $pick');

  // 实用：打乱顺序
  var cards = [1, 2, 3, 4, 5, 6, 7];
  cards.shuffle(rng);
  print('  打乱后: $cards');

  // ========== 6. 三角函数 ==========
  print('\n--- 6. 三角函数 ---');
  print('  sin(π/2) = ${sin(pi / 2).toStringAsFixed(1)}'); // 1.0
  print('  cos(0)   = ${cos(0).toStringAsFixed(1)}');      // 1.0
  print('  tan(π/4) = ${tan(pi / 4).toStringAsFixed(2)}'); // 1.0

  // 弧度 ↔ 角度
  double degToRad(double deg) => deg * pi / 180;
  double radToDeg(double rad) => rad * 180 / pi;
  print('  90° = ${degToRad(90).toStringAsFixed(2)} rad');  // 1.57
  print('  1.57 rad = ${radToDeg(1.57).toStringAsFixed(1)}°'); // 89.9°

  // ========== 7. 指数与对数 ==========
  print('\n--- 7. 指数与对数 ---');
  print('  exp(1)  = ${exp(1).toStringAsFixed(4)}');      // e^1 = 2.7183
  print('  log(e)  = ${log(e).toStringAsFixed(1)}');      // ln(e) = 1.0
  print('  log(100) / log(10) = ${log(100) / log(10)}');  // 以10为底 → 2.0

  // ========== 8. 取整函数 ==========
  print('\n--- 8. 取整函数 ---');
  double x = 3.7;
  print('  ceil(3.7)  = ${x.ceil()}');    // 4  向上取整
  print('  floor(3.7) = ${x.floor()}');   // 3  向下取整
  print('  round(3.7) = ${x.round()}');   // 4  四舍五入
  print('  trunc(3.7) = ${x.toInt()}');   // 3  截断小数

  // ========== 9. Point 二维坐标 ==========
  print('\n--- 9. Point 坐标 ---');
  var p1 = Point(3, 4);
  var p2 = Point(6, 8);
  print('  p1 = $p1');
  print('  p2 = $p2');
  print('  距离 = ${p1.distanceTo(p2)}');         // 5.0
  print('  平方距离 = ${p1.squaredDistanceTo(p2)}'); // 25.0
  print('  p1 + p2 = ${p1 + p2}');                 // (9, 12)
  print('  p1 * 2 = ${p1 * 2}');                   // (6, 8)
  print('  长度 = ${p1.magnitude.toStringAsFixed(2)}'); // 5.0

  // ========== 10. 实用：生成随机密码 ==========
  print('\n--- 10. 实用：生成随机密码 ---');

  String generatePassword({int len = 8, bool useSpecial = false}) {
    var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        'abcdefghijklmnopqrstuvwxyz'
        '0123456789';
    if (useSpecial) chars += '!@#\$%^&*()-_=+';
    var r = Random();
    return List.generate(len, (_) => chars[r.nextInt(chars.length)]).join();
  }

  print('  简单密码: ${generatePassword()}');          // 8位
  print('  复杂密码: ${generatePassword(len: 12, useSpecial: true)}');

  // ========== 11. 实用：正态分布随机数 ==========
  print('\n--- 11. 实用：正态分布（Box-Muller）---');

  double normalRandom(Random r) {
    // Box-Muller 变换：用均匀分布模拟正态分布
    var u1 = r.nextDouble();
    var u2 = r.nextDouble();
    return sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  }

  var r2 = Random();
  var samples = List.generate(5, (_) => normalRandom(r2));
  print('  正态分布样本: ${samples.map((e) => e.toStringAsFixed(2)).toList()}');

  print('\n程序结束');
}

/*
总结：dart:math

1. 数学常量: pi, e
2. 最值: max(a, b), min(a, b)
3. 幂运算: pow(base, exp) → double
4. 平方根: sqrt(x) → double
5. 随机数: Random()
   - .nextInt(n)  → 0..n-1
   - .nextDouble() → 0.0..1.0
   - .nextBool()  → true/false
   - Random(seed) → 固定种子，可复现
6. 三角函数: sin, cos, tan（参数是弧度）
7. 指数对数: exp(x), log(x)（自然对数）
8. 取整: ceil, floor, round, truncate
9. Point: 二维坐标，支持 +, *, distanceTo, dotProduct
10. 实用: Random 选元素、shuffle 打乱、密码生成

注意：
- pow 返回 double，需要 toInt() 取整
- 三角函数参数是弧度，不是角度
- log 是自然对数 ln，以10为底用 log(x) / log(10)
- Random() 是伪随机，不适合加密
- 固定种子方便测试（每次结果一样）
*/
