// Dart 第九课：Map 映射（键值对）

void main() {
  // 创建 Map
  Map<String, int> scores = {
    '语文': 90,
    '数学': 85,
    '英语': 92,
  };

  // 访问
  print('数学: ${scores['数学']}');

  // 添加 / 修改
  scores['物理'] = 88;   // 新增
  scores['数学'] = 95;   // 修改

  // 遍历
  scores.forEach((subject, score) {
    print('$subject: $score 分');
  });

  print('科目数: ${scores.length}');
}
