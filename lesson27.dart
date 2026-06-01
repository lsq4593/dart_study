// Dart 第二十七课：集合常用方法

void main() {
  var nums = [1, 2, 3, 4, 5, 6];

  // where — 过滤，保留符合条件的
  var evens = nums.where((n) => n.isEven);
  print('偶数: $evens');

  // map — 转换每个元素
  var doubled = nums.map((n) => n * n);
  print('平方: $doubled');

  // any — 有没有符合条件的？
  print('有大于5的吗: ${nums.any((n) => n > 5)}');

  // every — 全都符合条件？
  print('全都大于0吗: ${nums.every((n) => n > 0)}');

  // firstWhere — 找到第一个符合条件的
  print('第一个大于3的: ${nums.firstWhere((n) => n > 3)}');

  // 实战：筛选出及格的学生
  var scores = [55, 82, 91, 47, 73, 68];
  var passed = scores.where((s) => s >= 60);
  print('及格: $passed');
  print('平均分: ${passed.reduce((a, b) => a + b) / passed.length}');
}
