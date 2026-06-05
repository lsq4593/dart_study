// Dart 第五十三课：增强枚举（带字段和方法）

void main() {
  print('========== 增强枚举 ==========');

  // ========== 1. 基本用法 ==========
  print('\n--- 1. 状态码枚举 ---');
  var s = StatusCode.success;
  print('code:    ${s.code}');
  print('message: ${s.message}');
  print('isOk:    ${s.isOk}');
  print('format:  ${s.format()}');

  // ========== 2. 遍历所有枚举值 ==========
  print('\n--- 2. 遍历所有状态码 ---');
  for (var code in StatusCode.values) {
    print('  ${code.format()}');
  }

  // ========== 3. 颜色枚举 ==========
  print('\n--- 3. 颜色枚举 ---');
  print('红色:  ${Color.red.hexStr}');
  print('绿色:  ${Color.green.hexStr}');
  print('蓝色:  ${Color.blue.hexStr}');

  // ========== 4. 枚举实现接口 ==========
  print('\n--- 4. 实现接口 ---');
  void describe(Describable d) {
    print('  ${d.describe()}');
  }

  describe(Planet.mercury);
  describe(Planet.venus);
  describe(Planet.earth);
  describe(Planet.mars);

  // ========== 5. 枚举做运算 ==========
  print('\n--- 5. 枚举方法 ---');
  var p = Planet.earth;
  print('${p.name}: 质量=${p.mass}, 半径=${p.radius}');
  print('  表面重力: ${p.surfaceGravity.toStringAsFixed(2)} m/s²');

  // 计算在地球上的体重
  var weightOnEarth = 70.0; // kg
  for (var planet in Planet.values) {
    var weight = weightOnEarth * planet.surfaceGravity / 9.8;
    print('  在${planet.englishName}上: ${weight.toStringAsFixed(1)} kg');
  }

  // ========== 6. 解析枚举 ==========
  print('\n--- 6. 按名称解析枚举 ---');
  var parsed = StatusCode.parse(200);
  print('解析 200: ${parsed?.format()}');
  parsed = StatusCode.parse(404);
  print('解析 404: ${parsed?.format()}');
  parsed = StatusCode.parse(999);
  print('解析 999: ${parsed?.toString()}');

  // ========== 7. switch 全覆盖 ==========
  print('\n--- 7. switch 全覆盖 ---');
  void handleStatus(StatusCode code) {
    switch (code) {
      case StatusCode.success:
        print('  ✅ ${code.message}');
      case StatusCode.notFound:
        print('  ⚠️ ${code.message}');
      case StatusCode.error:
        print('  ❌ ${code.message}');
    }
  }

  handleStatus(StatusCode.success);
  handleStatus(StatusCode.notFound);
  handleStatus(StatusCode.error);
}

// ========== 增强枚举 1：状态码 ==========
enum StatusCode {
  success(200, '成功'),
  notFound(404, '未找到'),
  error(500, '服务器错误');

  final int code;
  final String message;

  const StatusCode(this.code, this.message);

  bool get isOk => code < 400;
  String format() => '[$code] $message';

  // 工厂方法：按 code 查找枚举
  static StatusCode? parse(int code) {
    try {
      return StatusCode.values.firstWhere((s) => s.code == code);
    } catch (_) {
      return null;
    }
  }
}

// ========== 增强枚举 2：颜色 ==========
enum Color {
  red(0xFF0000),
  green(0x00FF00),
  blue(0x0000FF);

  final int hex;
  const Color(this.hex);

  String get hexStr => '#${hex.toRadixString(16).padLeft(6, '0')}';
}

// ========== 接口：可描述的 ==========
abstract interface class Describable {
  String describe();
}

// ========== 增强枚举 3：行星（实现接口） ==========
enum Planet implements Describable {
  mercury(3.303e23, 2.4397e6),
  venus(4.869e24, 6.0518e6),
  earth(5.976e24, 6.37814e6),
  mars(6.421e23, 3.3972e6);

  final double mass;   // kg
  final double radius; // m

  const Planet(this.mass, this.radius);

  // 通用引力常数
  static const double G = 6.67430e-11;

  // 表面重力加速度
  double get surfaceGravity => G * mass / (radius * radius);

  // 英文名
  String get englishName => name[0].toUpperCase() + name.substring(1);

  @override
  String describe() => '$englishName (质量: ${mass.toStringAsExponential(2)} kg)';
}

/*
总结：增强枚举

1. 带字段
   enum Xxx {
     值1(字段值), 值2(字段值);
     final 类型 字段名;
     const Xxx(this.字段名);
   }

2. 带方法/getter
   String get 属性 => ...;
   void 方法() { ... }

3. 实现接口
   enum Xxx implements 接口 { ... }

4. 注意
   - 构造函数必须是 const
   - 枚举值在类体最后，用 ; 结尾
   - 可以加 static 方法和工厂方法
   - switch 全覆盖检查依然有效
*/
