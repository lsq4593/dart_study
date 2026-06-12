// Dart 练习题 — 第24题：迷你日志分析器
// 知识点：正则表达式、文件IO、Stream、StringBuffer、DateTime、排序、集合操作

/// 实现一个小型日志分析工具，解析、过滤、统计日志内容。
/// 用给定的 sampleLog 模拟日志数据（避免依赖真实文件）。

// ========== TODO 区域 ==========

/// 1. 定义 LogLevel 增强枚举
///    - info, warning, error, debug
///    - String get label → 中文标签（"信息"/"警告"/"错误"/"调试"）
///    - int get priority → 优先级（debug=0, info=1, warning=2, error=3）

// TODO: 定义 LogLevel 枚举



/// 2. 定义 LogEntry 类
///    - final DateTime timestamp
///    - final LogLevel level
///    - final String module
///    - final String message
///    - factory LogEntry.parse(String line) — 解析单行日志
///      格式: "[2024-01-15 10:30:45] [ERROR] [AuthService] 登录失败，用户不存在"
///      提示：用正则表达式提取各字段。如果解析失败返回 null。

// TODO: 实现 LogEntry 类及 factory parse



/// 3. 实现函数 List<LogEntry> parseLog(String rawLog)
///    将多行日志字符串按行拆分，逐行解析，跳过空行和解析失败的行

// TODO: 实现 parseLog 函数



/// 4. 给 List<LogEntry> 加扩展方法：
///    - List<LogEntry> filterByLevel(LogLevel level) — 按级别过滤
///    - List<LogEntry> filterByModule(String module) — 按模块过滤
///    - List<LogEntry> filterByDateRange(DateTime from, DateTime to) — 按日期范围
///    - Map<LogLevel, int> get levelStats — 统计各级别数量
///    - Map<String, int> get moduleStats — 统计各模块数量
///    - String get report — 生成格式化的分析报告

// TODO: 实现 LogListExtension



/// 5. 实现函数 String generateReport(List<LogEntry> logs)
///    生成格式化的分析报告，包含：
///    - 日志总条数
///    - 各级别分布（柱状图用 ███ 表示，每10条一块）
///    - 各模块分布
///    - 按时间排序的前5条 error 日志

// TODO: 实现 generateReport 函数



// ========== 给定数据 ==========

const String sampleLog = '''
[2024-01-15 08:01:23] [INFO] [UserService] 用户登录成功: user_id=1001
[2024-01-15 08:05:47] [DEBUG] [CacheManager] 缓存命中: key=user_1001_profile
[2024-01-15 08:12:34] [ERROR] [AuthService] 登录失败，用户不存在: email=test@test.com
[2024-01-15 08:15:01] [INFO] [OrderService] 新订单创建: order_id=ORD-20240115-0001
[2024-01-15 08:20:11] [WARNING] [OrderService] 库存不足: product_id=SKU-888, requested=10, available=3
[2024-01-15 08:25:33] [INFO] [PaymentService] 支付成功: order_id=ORD-20240115-0001, amount=399.00
[2024-01-15 08:30:55] [ERROR] [PaymentService] 支付超时: order_id=ORD-20240115-0002
[2024-01-15 08:35:12] [WARNING] [AuthService] 连续登录失败: user_id=1003, attempts=4
[2024-01-15 08:40:08] [INFO] [UserService] 用户注册成功: user_id=1005
[2024-01-15 08:45:19] [DEBUG] [CacheManager] 缓存写入: key=user_1005_profile
[2024-01-15 08:50:44] [ERROR] [DatabaseService] 数据库连接超时: host=db-primary, timeout=30s
[2024-01-15 08:55:01] [INFO] [OrderService] 订单发货: order_id=ORD-20240115-0001
[2024-01-15 09:00:22] [ERROR] [OrderService] 订单状态更新失败: order_id=ORD-20240115-0003
[2024-01-15 09:05:37] [WARNING] [CacheManager] 缓存淘汰: key=user_1002_profile, reason=TTL过期
[2024-01-15 09:10:15] [INFO] [UserService] 用户登出: user_id=1001
[2024-01-15 09:15:48] [ERROR] [PaymentService] 退款失败: order_id=ORD-20240115-0004, reason=余额不足
[2024-01-15 09:20:03] [INFO] [AuthService] 密码修改成功: user_id=1004
[2024-01-15 09:25:29] [WARNING] [DatabaseService] 慢查询检测: query=SELECT * FROM orders, duration=3.2s
[2024-01-15 09:30:44] [ERROR] [AuthService] Token验证失败: token=expired_jwt_xxx
[2024-01-15 09:35:10] [INFO] [OrderService] 订单完成: order_id=ORD-20240115-0001
''';

// ========== 测试代码（请勿修改）==========

void main() {
  print('========== 迷你日志分析器 ==========\n');

  // ---- 测试1：LogLevel 枚举 ----
  print('--- 测试1：LogLevel ---');
  for (final level in LogLevel.values) {
    print('  ${level.name} → ${level.label} (优先级: ${level.priority})');
  }

  // ---- 测试2：解析单行 ----
  print('\n--- 测试2：解析单行 ---');
  final line1 = LogEntry.parse('[2024-01-15 10:30:45] [ERROR] [AuthService] 登录失败');
  if (line1 != null) {
    print('  时间: ${line1.timestamp}');
    print('  级别: ${line1.level}');
    print('  模块: ${line1.module}');
    print('  消息: ${line1.message}');
  }

  // ---- 测试3：批量解析 ----
  print('\n--- 测试3：批量解析 ---');
  final logs = parseLog(sampleLog);
  print('  共解析 ${logs.length} 条日志');

  // ---- 测试4：过滤 ----
  print('\n--- 测试4：过滤 ---');
  final errors = logs.filterByLevel(LogLevel.error);
  print('  Error 日志: ${errors.length} 条');
  final authLogs = logs.filterByModule('AuthService');
  print('  AuthService 日志: ${authLogs.length} 条');

  // ---- 测试5：统计 ----
  print('\n--- 测试5：统计 ---');
  final levelStats = logs.levelStats;
  levelStats.forEach((level, count) {
    print('  ${level.label}: $count 条');
  });

  print('\n  模块分布:');
  final moduleStats = logs.moduleStats;
  moduleStats.forEach((module, count) {
    print('    $module: $count 条');
  });

  // ---- 测试6：生成报告 ----
  print('\n--- 测试6：分析报告 ---');
  print(logs.report);

  print('========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 迷你日志分析器 ==========
  //
  // --- 测试1：LogLevel ---
  //   debug → 调试 (优先级: 0)
  //   info → 信息 (优先级: 1)
  //   warning → 警告 (优先级: 2)
  //   error → 错误 (优先级: 3)
  //
  // --- 测试2：解析单行 ---
  //   时间: 2024-01-15 10:30:45.000
  //   级别: LogLevel.error
  //   模块: AuthService
  //   消息: 登录失败
  //
  // --- 测试3：批量解析 ---
  //   共解析 20 条日志
  //
  // --- 测试4：过滤 ---
  //   Error 日志: 6 条
  //   AuthService 日志: 4 条
  //
  // --- 测试5：统计 ---
  //   调试: 2 条
  //   信息: 7 条
  //   警告: 4 条
  //   错误: 7 条
  //
  //   模块分布:
  //     AuthService: 4 条
  //     CacheManager: 3 条
  //     DatabaseService: 2 条
  //     OrderService: 5 条
  //     PaymentService: 3 条
  //     UserService: 3 条
  //
  // --- 测试6：分析报告 ---
  // ...
}
