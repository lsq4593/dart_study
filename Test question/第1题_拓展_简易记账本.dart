// Dart 练习题 — 第1题 拓展④：简易记账本
// 知识点：变量、List、Map、函数、循环、条件判断、算术运算、字符串插值
//
// 实现一个简易记账本，记录收支，统计总收入/支出/结余。

void main() {
  print('========== 简易记账本 ==========\n');

  // ====== 第1步：初始化账单 ======
  // 创建一个 List<Map<String, dynamic>> 存储每笔账单
  // 每笔账单包含：
  //   - 'type': '收入' 或 '支出'
  //   - 'category': 分类（'餐饮'/'购物'/'工资'/'交通'/'其他'）
  //   - 'amount': double 金额
  //   - 'note': String 备注
  // 至少预置 8 笔账单

  // TODO: 创建 bills 列表
  List<Map<String, dynamic>> bills = [
    {'type': '收入', 'category': '工资', 'amount': 5000.0, 'note': '1月工资'},
    {'type': '支出', 'category': '餐饮', 'amount': 35.0, 'note': '午餐'},
    {'type': '支出', 'category': '购物', 'amount': 299.0, 'note': '买书'},
    {'type': '支出', 'category': '交通', 'amount': 15.0, 'note': '地铁充值'},
    {'type': '收入', 'category': '其他', 'amount': 200.0, 'note': '红包'},
    {'type': '支出', 'category': '餐饮', 'amount': 68.0, 'note': '晚餐'},
    {'type': '支出', 'category': '购物', 'amount': 89.0, 'note': '日用品'},
    {'type': '收入', 'category': '工资', 'amount': 5000.0, 'note': '2月工资'},
  ];

  // ====== 第2步：打印账单 ======
  // 写一个函数 void printBills(List<Map<String, dynamic>> bills)
  // 打印所有账单，格式：序号. [收入/支出] 分类: ±金额元 - 备注

  // TODO: 实现 printBills 函数
  void printBills(List<Map<String, dynamic>> bills) {
    for (int i = 0; i < bills.length; i++) {
      var b = bills[i];
      String sign = b['type'] == '收入' ? '+' : '-';
      print(
        '${i + 1}. [${b['type']}] ${b['category']}:${sign}${(b['amount'] as double).toStringAsFixed(2)}元 - ${b['note']}',
      );
    }
  }

  print('--- 全部账单 ---');
  printBills(bills);

  // ====== 第3步：统计总收入、总支出、结余 ======
  // 写三个函数：
  //   double totalIncome(List<Map<String, dynamic>> bills)  → 总收入
  //   double totalExpense(List<Map<String, dynamic>> bills) → 总支出
  //   double balance(List<Map<String, dynamic>> bills)      → 结余（收入 - 支出）

  // TODO: 实现统计函数
  double totalIncome(List<Map<String, dynamic>> bills) {
    double sum = 0;
    for (var b in bills) {
      if (b['type'] == '收入') sum += b['amount'] as double;
    }
    return sum;
  }

  double totalExpense(List<Map<String, dynamic>> bills) {
    double sum = 0;
    for (var b in bills) {
      if (b['type'] == '支出') sum += b['amount'] as double;
    }
    return sum;
  }

  double balance(List<Map<String, dynamic>> bills) {
    return totalIncome(bills) - totalExpense(bills);
  }

  print('\n--- 汇总 ---');
  double income = totalIncome(bills);
  double expense = totalExpense(bills);
  double bal = balance(bills);
  print('  总收入: ${income.toStringAsFixed(2)}元');
  print('  总支出: ${expense.toStringAsFixed(2)}元');
  print('  结余: ${bal.toStringAsFixed(2)}元');

  // 用三元运算符判断是否超支
  String financeStatus = bal >= 0 ? '💰 财务状况良好' : '⚠️  入不敷出！';
  print('  $financeStatus');

  // ====== 第4步：按分类汇总 ======
  // 写一个函数 Map<String, double> categorySummary(List<Map<String, dynamic>> bills, String type)
  // 按分类汇总指定类型（收入/支出）的金额
  // 例如 categorySummary(bills, '支出') → {'餐饮': 103.0, '购物': 388.0, ...}

  // TODO: 实现 categorySummary 函数
  Map<String, double> categorySummary(
    List<Map<String, dynamic>> bills,
    String type,
  ) {
    Map<String, double> summary = {};
    for (var b in bills) {
      if (b['type'] == type) {
        String cat = b['category'] as String;
        double amt = b['amount'] as double;
        summary[cat] = (summary[cat] ?? 0) + amt;
      }
    }
    return summary;
  }

  print('\n--- 支出分类汇总 ---');
  var expenseByCat = categorySummary(bills, '支出');
  for (var entry in expenseByCat.entries) {
    print('  ${entry.key}: ${entry.value.toStringAsFixed(2)}元');
  }

  // ====== 第5步：找出最大单笔支出 ======
  // 遍历 bills，找出金额最大的支出

  // TODO: 找出最大单笔支出
  double maxExpense = 0;
  String maxExpenseNote = '';

  print('\n最大单笔支出: ${maxExpense.toStringAsFixed(2)}元 (${maxExpenseNote})');

  // ====== 第6步：按类别过滤 ======
  // 写一个函数 List<Map<String, dynamic>> filterByCategory(List<Map<String, dynamic>> bills, String category)
  // 返回指定类别的所有账单

  // TODO: 实现 filterByCategory 函数
  List<Map<String, dynamic>> filterByCategory(
    List<Map<String, dynamic>> bills,
    String category,
  ) {
    return []; // 替换这行
  }

  print('\n--- 餐饮类账单 ---');
  var foodBills = filterByCategory(bills, '餐饮');
  for (var b in foodBills) {
    print('  ${b['type']} ${b['amount']}元 - ${b['note']}');
  }

  // ====== 第7步：月均支出 ======
  // 假设所有账单覆盖了 N 个月，计算月均支出

  // TODO: 计算月均支出
  int monthCount = 2;
  double avgMonthlyExpense = 0.0;

  print('\n月均支出: ${avgMonthlyExpense.toStringAsFixed(2)}元');

  print('\n========== 记账完成 ==========');
}
