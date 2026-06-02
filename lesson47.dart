// Dart 第四十七课：JSON 编解码 (dart:convert)

import 'dart:convert';

void main() {
  // ========== 1. JSON → Dart 对象 (jsonDecode) ==========
  // JSON 字符串 → Map / List（动态类型）

  var jsonStr = '{"name": "小明", "age": 25, "isStudent": false}';
  var user = jsonDecode(jsonStr);
  // user 是 dynamic 类型，实际是 Map<String, dynamic>

  print(user.runtimeType); // _Map<String, dynamic>
  print(user['name']); // 小明
  print(user['age']); // 25
  print(user['isStudent']); // false

  // JSON 数组
  var listJson = '[{"name": "小红"}, {"name": "小刚"}]';
  var users = jsonDecode(listJson) as List<dynamic>;
  print(users[0]['name']); // 小红
  print(users[1]['name']); // 小刚

  // ========== 2. Dart 对象 → JSON (jsonEncode) ==========
  // Map / List → JSON 字符串

  var map = {
    'name': '小红',
    'age': 22,
    'scores': [95, 88, 92],
  };
  var jsonOut = jsonEncode(map);
  print(jsonOut); // {"name":"小红","age":22,"scores":[95,88,92]}

  // List 转 JSON
  var list = [
    {'name': '张三', 'age': 20},
    {'name': '李四', 'age': 21},
  ];
  print(jsonEncode(list));
  // [{"name":"张三","age":20},{"name":"李四","age":21}]

  // ========== 3. 中文编码（默认正常，用 UTF-8） ==========
  // jsonEncode 默认对中文不做转义，直接输出
  var cn = {'name': '你好世界'};
  print(jsonEncode(cn)); // {"name":"你好世界"}

  // 如果非要转义成 \uXXXX，可以用 toUtf8Encoder
  // 但一般不需要，默认的 UTF-8 输出就行

  // ========== 4. 类对象 ←→ JSON（手动序列化） ==========
  // jsonEncode/jsonDecode 只认识 Map/List，不认识自定义类
  // 所以需要自己写 toJson() 和 fromJson() 方法

  // 对象 → JSON
  var p = Person('小明', 25, true);
  var pJson = jsonEncode(p.toJson());
  print(pJson); // {"name":"小明","age":25,"isStudent":true}

  // JSON → 对象
  var pMap = jsonDecode(pJson) as Map<String, dynamic>;
  var p2 = Person.fromJson(pMap);
  print(p2.name); // 小明
  print(p2.age); // 25

  // ========== 5. 嵌套对象序列化 ==========
  // 当对象里包含其他对象时，也要处理内部的 toJson

  var classroom = Classroom('三年二班', [
    Person('小红', 22, true),
    Person('小刚', 23, false),
  ]);
  print(jsonEncode(classroom.toJson()));
  // {"name":"三年二班","students":[{"name":"小红","age":22,"isStudent":true},{"name":"小刚","age":23,"isStudent":false}]}

  // 反向解析
  var classJson =
      jsonDecode('''
    {
      "name": "三年一班",
      "students": [
        {"name": "张三", "age": 20, "isStudent": true},
        {"name": "李四", "age": 21, "isStudent": true}
      ]
    }
  ''')
          as Map<String, dynamic>;
  var c2 = Classroom.fromJson(classJson);
  print('${c2.name}: ${c2.students.length} 名学生');

  // ========== 6. jsonEncode 的自定义规则 ==========
  // 除了 toJson，还可以给 jsonEncode 传第二个参数：
  //   一个函数，遇到不认识的对象时调用

  var strange = {
    'point': Point(3, 4), // Point 没有 toJson
  };

  // 方式一：给 jsonEncode 传 toEncodable 回调
  var result = jsonEncode(
    strange,
    toEncodable: (object) {
      if (object is Point) {
        return {'x': object.x, 'y': object.y};
      }
      return object;
    },
  );
  print(result); // {"point":{"x":3,"y":4}}

  // 方式二：实现 toJson() 方法（推荐，更规范）
  // jsonEncode 会自动检查对象是否含有 toJson 方法

  // ========== 7. 格式化输出（缩进美化） ==========
  var data = {
    'name': '测试',
    'items': [1, 2, 3],
    'meta': {'version': '1.0'},
  };

  // 用 JsonEncoder 的 withIndent 方法
  var encoder = const JsonEncoder.withIndent('  '); // 两个空格缩进
  print(encoder.convert(data));
  // {
  //   "name": "测试",
  //   "items": [
  //     1,
  //     2,
  //     3
  //   ],
  //   "meta": {
  //     "version": "1.0"
  //   }
  // }

  // ========== 8. 处理 JSON 中的 null 和缺失字段 ==========
  var rawJson = '{"name": "测试"}'; // 没有 age 字段
  var rawMap = jsonDecode(rawJson) as Map<String, dynamic>;

  // ❌ 直接取值可能得到 null
  var age = rawMap['age']; // null（没这个键）
  print(age); // null

  // ✅ 安全的做法：提供默认值
  var safeAge = rawMap['age'] ?? 0; // 没有就用 0
  print(safeAge); // 0

  // 另一种：检查键是否存在
  if (rawMap.containsKey('email')) {
    print(rawMap['email']);
  } else {
    print('没有 email 字段');
  }

  // ========== 9. 实际场景：API 响应解析 ==========
  var apiResponse = '''
  {
    "code": 200,
    "message": "成功",
    "data": {
      "total": 2,
      "list": [
        {"id": 1, "title": "文章1", "createdAt": "2026-06-01"},
        {"id": 2, "title": "文章2", "createdAt": "2026-06-02"}
      ]
    }
  }
  ''';

  var response = jsonDecode(apiResponse) as Map<String, dynamic>;

  if (response['code'] == 200) {
    var data = response['data'] as Map<String, dynamic>;
    var total = data['total'];
    var articles = data['list'] as List<dynamic>;

    print('共 $total 篇文章：');
    for (var article in articles) {
      print(
        '  [${article['id']}] ${article['title']} (${article['createdAt']})',
      );
    }
  }

  // ========== 10. JSON 解码时类型转换注意 ==========
  // jsonDecode 的规则：
  //   JSON 类型   → Dart 类型
  //   string      → String
  //   number      → int（整数）或 double（小数）
  //   boolean     → bool
  //   null        → null
  //   array       → List<dynamic>
  //   object      → Map<String, dynamic>

  var precise = jsonDecode('{"a": 1, "b": 1.5, "c": 10000000000}');
  print(precise['a'].runtimeType); // int
  print(precise['b'].runtimeType); // double
  // 特别大的整数可能会被解析成 double！
  print(precise['c'].runtimeType); // int（Dart 2.2+ 支持大整数）
}

// ========== 自定义类：Person ==========
class Person {
  final String name;
  final int age;
  final bool isStudent;

  Person(this.name, this.age, this.isStudent);

  // 对象 → Map（供 jsonEncode 调用）
  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'isStudent': isStudent,
  };

  // Map → 对象（工厂构造函数）
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['name'] as String,
      json['age'] as int,
      json['isStudent'] as bool,
    );
  }
}

// ========== 自定义类：Classroom（含嵌套对象） ==========
class Classroom {
  final String name;
  final List<Person> students;

  Classroom(this.name, this.students);

  Map<String, dynamic> toJson() => {
    'name': name,
    'students': students.map((s) => s.toJson()).toList(),
  };

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      json['name'] as String,
      (json['students'] as List)
          .map((s) => Person.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ========== 辅助类：Point ==========
class Point {
  final int x, y;
  Point(this.x, this.y);
}

/*
总结：JSON 编解码核心操作

1. 基本操作
   jsonDecode(jsonStr)          — JSON 字符串 → Map/List
   jsonEncode(map)              — Map/List → JSON 字符串

2. 自定义类处理（标准做法）
   实现 toJson() → Map<String, dynamic>
   实现 factory fromJson(Map) → 对象

3. 格式化输出
   JsonEncoder.withIndent('  ').convert(data)

4. 注意点
   - jsonDecode 返回的是 dynamic，通常需要 as 转换
   - JSON number 的整数部分 → int，小数 → double
   - 嵌套对象要在 toJson/fromJson 里递归处理
   - 缺失字段用 ?? 提供默认值，或用 containsKey 判断
   - jsonEncode 会自动调用对象的 toJson() 方法（如果存在）

5. 对比

| | jsonDecode | jsonEncode |
|---|---|---|
| 方向 | JSON → Dart | Dart → JSON |
| 输入/输出 | 字符串 → Map/List | Map/List → 字符串 |
| 自定义类 | 需要 fromJson | 需要 toJson |
*/
