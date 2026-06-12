// Dart 综合练习题 — 第1题 拓展：学生成绩系统进阶
// 知识点：排序、Set、extension、Record、Stream、JSON、StringBuffer、Iterable链式调用
// 基于第1题的成绩数据继续扩展

import 'dart:async';
import 'dart:convert';

void main() async {
  // ===== 基础数据（沿用第1题） =====
  Map<String, int> scores = {
    '小红': 92,
    '小明': 85,
    '小刚': 58,
    '小李': 73,
    '小文': 66,
    '小强': 95,
    '小芳': 47,
  };

  // ===== 第1步：按分数排序 =====
  // 用 sort + Comparator 按分数从高到低排序，打印排名
  // 格式: "第1名: 小红 92分"

  var entries = scores.entries.toList();
  // 转数组
  entries.sort((a, b) => b.value.compareTo(a.value)); // 降序
  for (int i = 0; i < entries.length; i++) {
    print('第${i + 1}名: ${entries[i].key} ${entries[i].value}分');
  }

  // ===== 第2步：统计各等级人数 =====
  // 统计每个等级（优秀/良好/中等/及格/不及格）各有多少人
  // 返回 Map<String, int>

  String getGrade(int score) {
    if (score >= 90) return '优秀';
    if (score >= 80) return '良好';
    if (score >= 70) return '中等';
    if (score >= 60) return '及格';
    return '不及格';
  }

  var gradeCount = <String, int>{};
  for (var score in scores.values) {
    var grade = getGrade(score);
    gradeCount[grade] = (gradeCount[grade] ?? 0) + 1;
  }
  print('等级统计: $gradeCount');

  // ===== 第3步：用 Set 找出唯一分数 =====
  // 把所有分数转成 Set，打印不重复的分数有哪些

  var uniqueScores = scores.values.toSet();
  print('所有分数（去重后）: $uniqueScores');
  print('不重复的分数个数: ${uniqueScores.length}');

  // ===== 第4步：用 extension 给 Map 加统计方法 =====
  // 给 Map<String, int> 加扩展方法：
  //   - double get average     → 平均分
  //   - int get highest        → 最高分
  //   - int get lowest         → 最低分
  //   - List<String> get failed → 不及格名单

  print('平均分: ${scores.average}');
  print('最高分: ${scores.highest}');
  print('最低分: ${scores.lowest}');
  print('不及格名单: ${scores.failed}');

  // ===== 第5步：用 Record 返回多项统计 =====
  // 写一个函数 analyze(Map<String, int> scores)
  // 返回 (double avg, int max, int min, int passedCount, int failedCount)

  var result = analyze(scores);
  print('平均分: ${result.avg}');
  print('最高分: ${result.max}');
  print('最低分: ${result.min}');
  print('及格人数: ${result.passedCount}');
  print('不及格人数: ${result.failedCount}');

  // ===== 第6步：JSON 序列化 =====
  // 把 scores 转成 JSON 字符串，再解析回来

  var jsonStr = jsonEncode(scores);
  print('JSON 字符串: $jsonStr');

  var decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
  var restored = decoded.map((k, v) => MapEntry(k, v as int));
  print('解析回来: $restored');
  print('类型正确? ${restored is Map<String, int>}');

  // ===== 第7步：Stream 逐条处理 =====
  // 把 scores 转成 Stream，每条延迟 200ms 发出，用 where 过滤出不及格的

  var stream = Stream.fromIterable(scores.entries).asyncMap(
    (entry) => Future.delayed(Duration(milliseconds: 200), () => entry),
  );
  print('不及格的学生:');
  await for (var entry in stream.where((e) => e.value < 60)) {
    print('  ${entry.key}: ${entry.value}分');
  }

  // ===== 第8步：生成格式化的成绩报表 =====
  // 用 StringBuffer 生成以下格式的报表：
  // ========== 成绩报表 ==========
  // 姓名      分数  等级
  // -------------------------
  // 小红       92  优秀
  // 小明       85  良好
  // ...
  // ============================
  // 平均分: xx.x
  // 及格率: xx.x%

  var sb = StringBuffer();
  sb.writeln('========== 成绩报表 ==========');
  sb.writeln('姓名\t\t分数\t等级');
  sb.writeln('-------------------------');

  String getGrade2(int score) {
    if (score >= 90) return '优秀';
    if (score >= 80) return '良好';
    if (score >= 70) return '中等';
    if (score >= 60) return '及格';
    return '不及格';
  }

  var sorted = scores.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  for (var entry in sorted) {
    sb.writeln('${entry.key}\t\t${entry.value}\t${getGrade2(entry.value)}');
  }

  var total = scores.values.reduce((a, b) => a + b);
  var avg = total / scores.length;
  var passCount = scores.values.where((s) => s >= 60).length;
  var passRate = passCount / scores.length * 100;

  sb.writeln('===========================');
  sb.writeln('平均分: ${avg.toStringAsFixed(1)}');
  sb.writeln('及格率: ${passRate.toStringAsFixed(1)}%');

  print(sb.toString());
}

// ===== extension 定义（第4步）=====
extension ScoreStats on Map<String, int> {
  double get average {
    if (isEmpty) return 0;
    return values.reduce((a, b) => a + b) / length;
  }

  int get highest => values.reduce((a, b) => a > b ? a : b);

  int get lowest => values.reduce((a, b) => a < b ? a : b);

  List<String> get failed {
    return entries.where((e) => e.value < 60).map((e) => e.key).toList();
  }
}

// ===== analyze 函数（第5步）=====
({double avg, int max, int min, int passedCount, int failedCount}) analyze(
  Map<String, int> scores,
) {
  if (scores.isEmpty)
    return (avg: 0, max: 0, min: 0, passedCount: 0, failedCount: 0);

  var avg = scores.values.reduce((a, b) => a + b) / scores.length;
  var max = scores.values.reduce((a, b) => a > b ? a : b);
  var min = scores.values.reduce((a, b) => a < b ? a : b);
  var passedCount = scores.values.where((s) => s >= 60).length;
  var failedCount = scores.length - passedCount;

  return (
    avg: avg,
    max: max,
    min: min,
    passedCount: passedCount,
    failedCount: failedCount,
  );
}
