// Dart 第七十九课：SQLite 数据库
// 使用 package:sqlite3 操作关系型数据库
// 对比第77课的 sembast（NoSQL）：
//
//   特性       sembast (NoSQL)        SQLite (关系型)
//   ─────     ─────────────          ─────────────
//   数据结构   文档 (Map)              表 (行+列)
//   查询方式   Finder/Filter           SQL 语句
//    schema   无                       CREATE TABLE 定义
//   适合场景   配置、简单存储            复杂查询、关联数据

import 'package:sqlite3/sqlite3.dart';

// ═══════════════════════════════════════════════════
//  数据模型
// ═══════════════════════════════════════════════════

class Student {
  final int id;
  final String name;
  final int age;
  final double score;

  Student(this.id, this.name, this.age, this.score);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'score': score,
      };

  @override
  String toString() => 'Student(id=$id, name=$name, age=$age, score=$score)';
}

// ═══════════════════════════════════════════════════
//  数据库访问层
// ═══════════════════════════════════════════════════

class StudentDb {
  late final Database _db;

  /// 打开数据库（不存在则自动创建）
  void open(String path) {
    _db = sqlite3.open(path);
    _initTable();
  }

  void close() => _db.close();

  /// 建表（如果不存在）
  void _initTable() {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS students (
        id    INTEGER PRIMARY KEY AUTOINCREMENT,
        name  TEXT    NOT NULL,
        age   INTEGER NOT NULL,
        score REAL    NOT NULL DEFAULT 0.0
      )
    ''');
  }

  // ──── CRUD ────

  /// CREATE — 插入学生
  Student create(String name, int age, double score) {
    _db.execute(
      'INSERT INTO students (name, age, score) VALUES (?, ?, ?)',
      [name, age, score],
    );
    final id = _db.lastInsertRowId;
    return Student(id, name, age, score);
  }

  /// READ — 查询全部
  List<Student> findAll() {
    final rows = _db.select('SELECT * FROM students ORDER BY id');
    return rows.map(_rowToStudent).toList();
  }

  /// READ — 按 ID 查询
  Student? findById(int id) {
    final rows = _db.select('SELECT * FROM students WHERE id = ?', [id]);
    if (rows.isEmpty) return null;
    return _rowToStudent(rows.first);
  }

  /// READ — 条件查询（按分数筛选）
  List<Student> findByScore(double min, double max) {
    final rows = _db.select(
      'SELECT * FROM students WHERE score BETWEEN ? AND ? ORDER BY score DESC',
      [min, max],
    );
    return rows.map(_rowToStudent).toList();
  }

  /// UPDATE — 更新
  Student? update(int id, {String? name, int? age, double? score}) {
    final parts = <String>[];
    final values = <Object?>[];
    if (name != null) { parts.add('name = ?'); values.add(name); }
    if (age != null)  { parts.add('age = ?');  values.add(age); }
    if (score != null){ parts.add('score = ?');values.add(score); }
    if (parts.isEmpty) return findById(id);

    values.add(id);
    _db.execute('UPDATE students SET ${parts.join(', ')} WHERE id = ?', values);
    return findById(id);
  }

  /// DELETE — 删除
  bool delete(int id) {
    _db.execute('DELETE FROM students WHERE id = ?', [id]);
    return _db.updatedRows > 0;
  }

  /// 行数据 → Student 对象
  Student _rowToStudent(Row row) => Student(
        row['id'] as int,
        row['name'] as String,
        row['age'] as int,
        row['score'] as double,
      );

  // ──── 高级操作 ────

  /// 聚合查询：统计信息
  Map<String, dynamic> stats() {
    final row = _db.select('''
      SELECT
        COUNT(*)   AS total,
        ROUND(AVG(score), 1) AS avg_score,
        MAX(score) AS max_score,
        MIN(score) AS min_score
      FROM students
    ''').first;
    return {
      'total': row['total'] as int,
      'avgScore': row['avg_score'] as double,
      'maxScore': row['max_score'] as double,
      'minScore': row['min_score'] as double,
    };
  }

  /// 事务操作：批量插入
  void batchCreate(List<Map<String, dynamic>> dataList) {
    _db.execute('BEGIN TRANSACTION');
    try {
      for (final data in dataList) {
        _db.execute(
          'INSERT INTO students (name, age, score) VALUES (?, ?, ?)',
          [data['name'], data['age'], data['score']],
        );
      }
      _db.execute('COMMIT');
    } catch (e) {
      _db.execute('ROLLBACK');
      rethrow;
    }
  }
}

// ═══════════════════════════════════════════════════
//  主程序
// ═══════════════════════════════════════════════════

void main() {
  final db = StudentDb();
  db.open('students.db');

  print('═══ SQLite 数据库操作 ═══');
  print('');

  // 1. CREATE — 插入数据
  print('── 1. CREATE ──');
  db.create('张三', 20, 85.5);
  db.create('李四', 22, 92.0);
  db.create('王五', 19, 76.5);
  db.create('赵六', 21, 95.5);
  db.create('孙七', 23, 68.0);
  print('  已插入 5 条记录');
  print('');

  // 2. READ — 查询全部
  print('── 2. READ 全部 ──');
  for (final s in db.findAll()) {
    print('  $s');
  }
  print('');

  // 3. READ — 按 ID 查询
  print('── 3. READ 按 ID ──');
  final found = db.findById(3);
  print('  id=3 → ${found ?? "不存在"}');
  print('');

  // 4. READ — 条件查询
  print('── 4. READ 条件查询 (score >= 80) ──');
  for (final s in db.findByScore(80, 100)) {
    print('  $s');
  }
  print('');

  // 5. READ — 聚合统计
  print('── 5. 聚合统计 ──');
  final stats = db.stats();
  print('  总人数: ${stats['total']}');
  print('  平均分: ${stats['avgScore']}');
  print('  最高分: ${stats['maxScore']}');
  print('  最低分: ${stats['minScore']}');
  print('');

  // 6. UPDATE — 更新
  print('── 6. UPDATE ──');
  db.update(1, name: '张三丰', score: 90.0);
  print('  更新后: ${db.findById(1)}');
  print('');

  // 7. DELETE — 删除
  print('── 7. DELETE ──');
  db.delete(5);
  print('  删除后剩余: ${db.findAll().length} 条');
  print('');

  // 8. 事务 — 批量插入
  print('── 8. 事务批量插入 ──');
  db.batchCreate([
    {'name': '周八', 'age': 20, 'score': 88.0},
    {'name': '吴九', 'age': 21, 'score': 91.5},
    {'name': '郑十', 'age': 22, 'score': 79.0},
  ]);
  print('  批量插入后: ${db.findAll().length} 条');
  print('');

  // 9. 打印最终数据
  print('═══ 最终数据 ═══');
  for (final s in db.findAll()) {
    print('  #${s.id}  ${s.name}  ${s.age}岁  ${s.score}分');
  }
  print('');

  db.close();
  print('数据库已关闭');

  // 验证：删除数据库文件，下次运行重新开始
  // File('students.db').deleteSync();
}
