// Dart 练习题 — 第23题：订单状态机
// 知识点：sealed class、switch 表达式、模式匹配、不可变对象、copyWith、增强枚举

/// 实现一个订单系统的状态管理，使用 sealed class 表达不同状态，
/// 用 copyWith 做不可变更新，用 switch 表达式做状态转换。
/// 完成下方 TODO 区域，使 main 函数能正确运行。

// ========== TODO 区域 ==========

/// 1. 定义 sealed class OrderState，表示订单状态
///    - OrderPending(String? paymentMethod) — 待支付，paymentMethod 为空表示未选择
///    - OrderPaid(DateTime paidAt, String paymentMethod) — 已支付
///    - OrderShipped(DateTime shippedAt, String trackingNumber) — 已发货
///    - OrderDelivered(DateTime deliveredAt) — 已送达
///    - OrderCancelled(DateTime cancelledAt, String reason) — 已取消

// TODO: 定义 OrderState sealed class



/// 2. 给 OrderState 加方法：
///    - bool get isActive — 返回 true 如果状态是 pending / paid / shipped
///    - String get statusText — 返回中文状态文字
///    - 用 switch 表达式实现

// TODO: 添加 isActive 和 statusText



/// 3. 定义 OrderItem 类：
///    - final String name
///    - final int quantity
///    - final double price
///    - double get total → quantity * price
///    - copyWith 方法

// TODO: 实现 OrderItem 类



/// 4. 定义 Order 类（不可变）：
///    - final String id
///    - final List<OrderItem> items
///    - final OrderState state
///    - double get total → items 的 total 之和
///    - Order copyWith({String? id, List<OrderItem>? items, OrderState? state})
///    - String get summary → 调用 formatOrder(this) 生成摘要

// TODO: 实现 Order 类



/// 5. 实现函数 String formatOrder(Order order)
///    用 switch 表达式匹配 order.state，返回格式化的订单摘要：
///    - Pending:   "订单[ID] | 待支付 | 共 N 件商品 | 总计 ¥xxx.xx"
///    - Paid:      "订单[ID] | 已支付(方式) | 支付时间 | 共 N 件商品 | 总计 ¥xxx.xx"
///    - Shipped:   "订单[ID] | 已发货 快递单号:xxx | 发货时间"
///    - Delivered: "订单[ID] | 已送达 | 送达时间"
///    - Cancelled: "订单[ID] | 已取消 | 原因:xxx | 取消时间"

// TODO: 实现 formatOrder 函数



/// 6. 实现函数 Order? tryTransition(Order order, OrderState newState)
///    返回状态转换后的新 Order，如果转换非法返回 null
///    规则：
///    - pending   → paid / cancelled ✅
///    - paid      → shipped / cancelled ✅
///    - shipped   → delivered ✅
///    - delivered → ❌ 终点状态
///    - cancelled → ❌ 终点状态
///    提示：用 switch 表达式匹配 (order.state, newState) 元组

// TODO: 实现 tryTransition 函数



// ========== 测试代码（请勿修改）==========

void main() {
  print('========== 订单状态机 ==========\n');

  // ---- 准备数据 ----
  final items = [
    OrderItem(name: '《Dart编程入门》', quantity: 2, price: 59.9),
    OrderItem(name: '机械键盘', quantity: 1, price: 399.0),
  ];

  // ---- 测试1：OrderItem ----
  print('--- 测试1：OrderItem ---');
  final item = items[0];
  print('${item.name} x${item.quantity} = ¥${item.total}');
  final item2 = item.copyWith(quantity: 3);
  print('修改后: ${item2.name} x${item2.quantity} = ¥${item2.total}');
  // 验证不可变
  print('原对象不变: ${item.quantity}');

  // ---- 测试2：Order 创建 ----
  print('\n--- 测试2：Order 创建 ---');
  final order = Order(
    id: 'ORD-2024-001',
    items: items,
    state: OrderPending(null),
  );
  print('创建订单: ${order.summary}');
  print('总金额: ¥${order.total}');

  // ---- 测试3：状态转换 ----
  print('\n--- 测试3：状态转换 ---');
  
  // 支付
  final paid = tryTransition(order, OrderPaid(
    DateTime.now(), '微信支付',
  ));
  if (paid != null) {
    print('支付成功: ${paid.summary}');
  }

  // 发货
  final shipped = tryTransition(paid!, OrderShipped(
    DateTime.now(), 'SF-1234567890',
  ));
  if (shipped != null) {
    print('发货成功: ${shipped.summary}');
  }

  // 送达
  final delivered = tryTransition(shipped!, OrderDelivered(DateTime.now()));
  if (delivered != null) {
    print('送达成功: ${delivered.summary}');
  }

  // ---- 测试4：非法转换 ----
  print('\n--- 测试4：非法转换 ---');
  final badCancel = tryTransition(delivered!, OrderCancelled(DateTime.now(), '不想要了'));
  print('已送达→取消: ${badCancel == null ? "❌ 不允许" : "✅ 允许"}');

  final badShip = tryTransition(order, OrderShipped(DateTime.now(), 'SF-xxx'));
  print('未支付→发货: ${badShip == null ? "❌ 不允许" : "✅ 允许"}');

  // ---- 测试5：取消订单 ----
  print('\n--- 测试5：取消订单 ---');
  final cancelled = tryTransition(order, OrderCancelled(DateTime.now(), '下单错误'));
  if (cancelled != null) {
    print('取消成功: ${cancelled.summary}');
  }

  // ---- 测试6：isActive 和 statusText ----
  print('\n--- 测试6：状态属性 ---');
  for (final state in [
    OrderPending(null),
    OrderPaid(DateTime.now(), '支付宝'),
    OrderShipped(DateTime.now(), 'SF-000'),
    OrderDelivered(DateTime.now()),
    OrderCancelled(DateTime.now(), '测试'),
  ]) {
    print('  ${state.statusText} | 活跃: ${state.isActive}');
  }

  print('\n========== 测试完成 ==========');

  /// 期望输出（供参考）：
  // ========== 订单状态机 ==========
  //
  // --- 测试1：OrderItem ---
  // 《Dart编程入门》 x2 = ¥119.8
  // 修改后: 《Dart编程入门》 x3 = ¥179.7
  // 原对象不变: 2
  //
  // --- 测试2：Order 创建 ---
  // 创建订单: 订单[ORD-2024-001] | 待支付 | 共2件商品 | 总计 ¥518.8
  // 总金额: ¥518.8
  //
  // --- 测试3：状态转换 ---
  // 支付成功: 订单[ORD-2024-001] | 已支付(微信支付) | 2024-... | 共2件商品 | 总计 ¥518.8
  // 发货成功: 订单[ORD-2024-001] | 已发货 快递单号:SF-1234567890 | 2024-...
  // 送达成功: 订单[ORD-2024-001] | 已送达 | 2024-...
  //
  // --- 测试4：非法转换 ---
  // 已送达→取消: ❌ 不允许
  // 未支付→发货: ❌ 不允许
  //
  // --- 测试5：取消订单 ---
  // 取消成功: 订单[ORD-2024-001] | 已取消 | 原因:下单错误 | 2024-...
  //
  // --- 测试6：状态属性 ---
  //   待支付 | 活跃: true
  //   已支付 | 活跃: true
  //   已发货 | 活跃: true
  //   已送达 | 活跃: false
  //   已取消 | 活跃: false
  //
  // ========== 测试完成 ==========
}
