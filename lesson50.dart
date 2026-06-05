// Dart 第五十课：排序与 Comparable

void main() {
  // ========== 1. 基础排序：sort() ==========
  print('========== 1. sort() 基础 ==========');
  var nums = [3, 1, 4, 1, 5, 9, 2, 6];
  nums.sort();
  print('数字升序: $nums'); // [1, 1, 2, 3, 4, 5, 6, 9]

  var names = ['小明', '小刚', '小红', '小李'];
  names.sort();
  print('字符串默认: $names'); // [小刚, 小明, 小红]（按拼音）

  // ========== 2. 自定义排序规则 ==========
  print('\n========== 2. 自定义排序 ==========');
  var nums2 = [3, 1, 4, 1, 5, 9, 2, 6];
  nums2.sort((a, b) => b.compareTo(a)); // 降序
  print('数字降序: $nums2'); // [9, 6, 5, 4, 3, 2, 1, 1]

  // 按字符串长度排序
  var words = ['apple', 'banana', 'cherry', 'date', 'elderberry'];
  words.sort((a, b) => a.length.compareTo(b.length));
  print('按长度排序: $words'); // [date, apple, banana, cherry, elderberry]

  // 先按长度，长度相同按字母
  words.sort((a, b) {
    var lenCmp = a.length.compareTo(b.length);
    if (lenCmp != 0) return lenCmp;
    return a.compareTo(b);
  });
  print('长度+字母: $words');

  // ========== 3. Comparable 接口 ==========
  print('\n========== 3. Comparable 接口 ==========');
  var students = [
    Student('小明', 85),
    Student('小红', 92),
    Student('小刚', 78),
    Student('小丽', 92),
  ];

  students.sort(); // 按 score 降序（compareTo 定义的规则）
  print('按分数排序:');
  for (var s in students) {
    print('  ${s.name}: ${s.score}分');
  }

  // ========== 4. 多种排序规则 ==========
  print('\n========== 4. 多种排序规则 ==========');

  void sortByName(List<Student> list) =>
      list.sort((a, b) => a.name.compareTo(b.name));
  void sortByScoreAsc(List<Student> list) =>
      list.sort((a, b) => a.score.compareTo(b.score));
  void sortByScoreDesc(List<Student> list) =>
      list.sort((a, b) => b.score.compareTo(a.score));

  // 重置数据
  students = [
    Student('小明', 85),
    Student('小红', 92),
    Student('小刚', 78),
    Student('小丽', 92),
  ];

  sortByName(students);
  print('按名字排序: ${students.map((s) => s.name).join(", ")}');

  sortByScoreAsc(students);
  print('按分数升序: ${students.map((s) => '${s.name}(${s.score})').join(", ")}');

  sortByScoreDesc(students);
  print('按分数降序: ${students.map((s) => '${s.name}(${s.score})').join(", ")}');

  // ========== 5. 多字段排序（成绩相同按名字） ==========
  print('\n========== 5. 多字段排序 ==========');
  var students2 = [
    Student('小明', 85),
    Student('小红', 92),
    Student('小刚', 78),
    Student('小丽', 92),
    Student('小强', 85),
  ];

  students2.sort((a, b) {
    var scoreCmp = b.score.compareTo(a.score); // 先按分数降序
    if (scoreCmp != 0) return scoreCmp;
    return a.name.compareTo(b.name); // 分数相同按名字升序
  });
  print('分数降序，同分按名字:');
  for (var s in students2) {
    print('  ${s.name}: ${s.score}分');
  }

  // ========== 6. 自定义对象不实现 Comparable 会怎样 ==========
  print('\n========== 6. 不实现 Comparable 会报错 ==========');
  var points = [MyPoint(3, 4), MyPoint(1, 2), MyPoint(5, 1)];
  // points.sort(); // ❌ 编译报错！MyPoint 没有实现 Comparable

  // 必须传入 Comparator
  points.sort((a, b) {
    var dA = a.x * a.x + a.y * a.y;
    var dB = b.x * b.x + b.y * b.y;
    return dA.compareTo(dB);
  });
  print('按距离原点排序:');
  for (var p in points) {
    print('  (${p.x}, ${p.y})');
  }

  // ========== 7. reversed 反转 ==========
  print('\n========== 7. reversed 反转 ==========');
  var list = [1, 2, 3, 4, 5];
  var reversed = list.reversed; // Iterable，不创建新 list
  print('原列表: $list');
  print('反转后: ${reversed.toList()}'); // [5, 4, 3, 2, 1]

  // ========== 8. 排序稳定吗？ ==========
  print('\n========== 8. 稳定排序 ==========');
  var items = [Item('张三', 10), Item('李四', 5), Item('王五', 10), Item('赵六', 5)];
  // Dart 的 sort() 是稳定排序：相等值的先后顺序不变
  items.sort((a, b) => a.value.compareTo(b.value));
  print('按 value 排序（稳定）:');
  for (var it in items) {
    print('  ${it.name}: ${it.value}');
  }
  // 原来张三(10)在王五(10)前面，排序后还是张三在王五前面
  // 原来李四(5)在赵六(5)前面，排序后还是李四在赵六前面

  // ========== 9. 实际场景：按日期排序 ==========
  print('\n========== 9. 按日期排序 ==========');
  var dates = [
    DateTime(2026, 6, 3),
    DateTime(2026, 5, 20),
    DateTime(2026, 6, 1),
    DateTime(2026, 4, 15),
  ];
  dates.sort(); // DateTime 已实现 Comparable
  print('日期升序:');
  for (var d in dates) {
    print(
      '  ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
    );
  }

  dates.sort((a, b) => b.compareTo(a)); // 降序
  print('日期降序:');
  for (var d in dates) {
    print(
      '  ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
    );
  }
}

// ========== 学生类：实现 Comparable ==========
class Student implements Comparable<Student> {
  final String name;
  final int score;

  Student(this.name, this.score);

  @override
  int compareTo(Student other) {
    // 分数降序排列（高分的排前面）
    return other.score.compareTo(score);
  }

  @override
  String toString() => '$name: $score';
}

// ========== 普通类：不实现 Comparable ==========
class MyPoint {
  final int x, y;
  MyPoint(this.x, this.y);
}

// ========== 测试稳定排序用 ==========
class Item {
  final String name;
  final int value;
  Item(this.name, this.value);
}

/*
总结：排序

1. 基本排序
   list.sort()                          — 默认升序（元素需实现 Comparable）
   list.sort((a,b) => a.compareTo(b))   — 升序
   list.sort((a,b) => b.compareTo(a))   — 降序

2. Comparable 接口
   类 implements Comparable<类>
   实现 int compareTo(其他)
   return 负/0/正 表示 前/相等/后

3. 多字段排序
   先比较主字段，不等就返回
   相等再比较次字段

4. 常见已实现 Comparable 的类型
   int、double、String、DateTime、Duration

5. 注意
   - 自定义对象不实现 Comparable 就调 sort() → 编译报错
   - Dart 的 sort() 是稳定排序：相等值保持原顺序
   - .reversed 返回 Iterable，不是新 List
*/
