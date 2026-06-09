// Dart 第六十二课：模式匹配进阶

void main() {
  print('========== 模式匹配进阶 ==========');

  // ========== 1. Guard（when 条件） ==========
  print('\n--- 1. Guard when ---');

  void describePair((int, int) pair) {
    switch (pair) {
      case (int x, int y) when x == y:
        print('  相等: $x == $y');
      case (int x, int y) when x > y:
        print('  前大: $x > $y');
      case (int x, int y):
        print('  后大: $x < $y');
    }
  }

  describePair((3, 3));
  describePair((5, 2));
  describePair((2, 5));

  // ========== 2. Guard 实际场景 ==========
  print('\n--- 2. Guard 校验 ---');

  String checkScore(dynamic score) {
    return switch (score) {
      int n when n >= 90 => '优秀',
      int n when n >= 60 => '及格',
      int n => '不及格',
      String s when s.toLowerCase() == 'a' => '优秀',
      String s when s.toLowerCase() == 'b' => '及格',
      String s => '未知等级',
      _ => '非法输入',
    };
  }

  print('  95: ${checkScore(95)}');
  print('  75: ${checkScore(75)}');
  print('  30: ${checkScore(30)}');
  print('  "A": ${checkScore('A')}');
  print('  "C": ${checkScore('C')}');
  print('  true: ${checkScore(true)}');

  // ========== 3. Null-check 模式 ==========
  print('\n--- 3. Null-check ---');

  void describe(String? name) {
    if (name case var n?) {         // n? = 非空才匹配
      print('  有值: $n (长度: ${n.length})');
    } else {
      print('  null');
    }
  }

  describe('小明');
  describe(null);

  // ========== 4. List 解构：剩余元素 ==========
  print('\n--- 4. List 解构 ... ---');

  var list1 = [1, 2, 3, 4, 5];
  var [a, b, ...rest] = list1;
  print('  [$a, $b, ...$rest]');

  // 取前 N 个，剩下的
  var [first, ...middle, last] = [1, 2, 3, 4, 5];
  print('  first=$first, middle=$middle, last=$last');

  // 取前 2 个，中间任意，最后一个
  var [x, y, ..., z] = [1, 2, 3, 4, 5];
  print('  x=$x, y=$y, z=$z');

  // ========== 5. 嵌套解构 ==========
  print('\n--- 5. 嵌套解构 ---');

  // Map 嵌套
  var json = {
    'user': '小明',
    'scores': [85, 92, 78],
    'meta': {'age': 25, 'city': '北京'},
  };

  // Map 解构
  var {'user': n, 'scores': scores} = json;
  print('  姓名: $n, 分数: $scores');

  // switch 嵌套解构
  var data = {'name': '小红', 'info': {'age': 22, 'city': '上海'}};
  switch (data) {
    case {'name': var name, 'info': {'age': var age, 'city': var city}}:
      print('  姓名: $name, 年龄: $age, 城市: $city');
    default:
      print('  格式错误');
  }

  // ========== 6. Switch 表达式解构 ==========
  print('\n--- 6. Switch 表达式 ---');

  var points = [(0, 0), (1, 0), (0, 1), (1, 1)];

  for (var p in points) {
    var desc = switch (p) {
      (0, 0) => '原点',
      (int x, 0) => 'X轴上: $x',
      (0, int y) => 'Y轴上: $y',
      (int x, int y) => '坐标: ($x, $y)',
    };
    print('  $p → $desc');
  }

  // ========== 7. 记录类型 + 模式 ==========
  print('\n--- 7. 记录类型 ---');

  (String name, int age, bool isStudent) user = ('小明', 25, false);

  var desc = switch (user) {
    (_, _, true) => '学生用户',
    (String n, _, _) when n.startsWith('小') => '姓小的用户',
    (_, int a, _) when a >= 18 => '成年用户',
    _ => '其他',
  };
  print('  $user → $desc');

  // ========== 8. 结合 sealed class ==========
  print('\n--- 8. sealed class + 模式 ---');

  Result result1 = Success('数据加载成功');
  Result result2 = Loading();
  Result result3 = Error('网络超时');
  Result result4 = Success('');

  for (var r in [result1, result2, result3, result4]) {
    var msg = switch (r) {
      Success(data: String d) when d.isEmpty => '成功但数据为空',
      Success(data: String d) => '成功: $d',
      Loading() => '加载中...',
      Error(message: String m) => '失败: $m',
    };
    print('  $msg');
  }

  print('\n程序结束');
}

// ========== sealed class ==========
sealed class Result {}

class Success extends Result {
  final String data;
  Success(this.data);
}

class Loading extends Result {}

class Error extends Result {
  final String message;
  Error(this.message);
}

/*
总结：模式匹配进阶

1. Guard (when)
   case (x, y) when x > y:
   匹配后加条件判断

2. Null-check
   case var n?:  只有非 null 才匹配

3. 剩余元素 (...)
   [a, ...rest]     → 头 + 剩余
   [first, ...mid, last] → 头 + 中间 + 尾
   [a, b, ..., z]   → 忽略中间

4. 嵌套解构
   var {'a': {'b': x}} = data

5. sealed class + switch
   编译器检查全覆盖 + 解构取值

6. switch 表达式
   var result = switch (value) { pattern => 返回值 };
*/
