// Dart 全课程综合练习题 — 第1题
// 知识点：变量、List、Map、函数、循环、条件判断、三元运算符、字符串插值

void main() {
  // 1. 创建一个 Map<String, int> 存储学生姓名和分数（至少5个学生）
  //    姓名用中文，分数在 50-100 之间
  //    例如: {'小明': 85, '小红': 92, ...}

  // TODO: 创建 scores Map
  Map<String, int> scores = {'小红': 90, '小明': 85, '小文': 92, '李华': 80, '赛维斯': 75};
  // 2. 创建一个函数 getPassedStudents(Map<String, int> scores)
  //    返回及格（>=60）的学生名单 List<String>

  List<String> getPassedStudents(Map<String, int> scores) {
    var passed = <String>[];
    scores.forEach((name, score) {
      if (score >= 60) passed.add(name);
    });
    return passed;
  }

  // 3. 用 for-in 遍历 Map 打印每个学生的成绩
  //    格式: "姓名: 分数 分"

  for (var entry in scores.entries) {
    print('${entry.key}: ${entry.value} 分');
  }

  // 4. 计算全班平均分（用 reduce 或 fold）

  var sum = scores.values.reduce((a, b) => a + b);
  var avg = sum / scores.length;
  print('全班平均分: ${avg.toStringAsFixed(1)}');

  // 5. 找出最高分和最低分（可以用 max/min 或自己实现）

  var maxScore = scores.values.reduce((a, b) => a > b ? a : b);
  var minScore = scores.values.reduce((a, b) => a < b ? a : b);
  print('最高分: $maxScore');
  print('最低分: $minScore');

  // 6. 根据分数给出等级：
  //    >= 90 → "优秀"
  //    >= 80 → "良好"
  //    >= 70 → "中等"
  //    >= 60 → "及格"
  //    < 60  → "不及格"
  //    打印每个人的姓名、分数和等级

  String getGrade(int score) {
    if (score >= 90) return '优秀';
    if (score >= 80) return '良好';
    if (score >= 70) return '中等';
    if (score >= 60) return '及格';
    return '不及格';
  }

  for (var entry in scores.entries) {
    print('${entry.key}: ${entry.value} 分 → ${getGrade(entry.value)}');
  }
}
