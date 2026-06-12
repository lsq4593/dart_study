// Dart 练习题 — 第1题 拓展①：购物车结算系统
// 知识点：变量、List、Map、函数、循环、条件判断、字符串插值
//
// 实现一个简单的购物车结算系统，计算商品总价、折扣和实付金额。

void main() {
  print('========== 购物车结算系统 ==========\n');

  // ====== 第1步：商品价格表 ======
  // 创建一个 Map<String, double> 存储商品名称和单价
  // 至少包含 6 种商品，例如：'苹果': 5.5, '香蕉': 3.0, ...

  // TODO: 创建 priceList Map
  Map<String, double> priceList = {
    '苹果': 3.0,
    '香蕉': 5.0,
    '橘子': 4.0,
    '橙子': 2.0,
    '火龙果': 5.0,
    '柚子': 12.0,
  };

  // ====== 第2步：购物车 ======
  // 创建一个 Map<String, int> 存储购买的商品和数量
  // 例如：'苹果': 3, '牛奶': 2, ...

  // TODO: 创建 cart Map
  Map<String, int> cart = {'苹果': 3, '香蕉': 2, '草莓': 1};

  // ====== 第3步：计算每件商品的小计 ======
  // 写一个函数 double calcSubtotal(Map<String, double> prices, String item, int qty)
  // 返回 单价 × 数量

  // TODO: 实现 calcSubtotal 函数
  double calcSubtotal(Map<String, double> prices, String item, int qty) {
    double price = prices[item] ?? 0.0;
    return price * qty;
  }

  // ====== 第4步：打印购物清单 ======
  // 用 for-in 遍历 cart，打印每件商品的名称、单价、数量和小计
  // 格式: "苹果  5.5元 × 3 = 16.50元"

  // TODO: 打印购物清单
  print('--- 购物清单 ---');
  for (MapEntry<String, int> item in cart.entries) {
    print(
      '${item.key} ${priceList[item.key]}元 ✖️ ${item.value} = ${((priceList[item.key] ?? 0.0) * item.value).toStringAsFixed(2)}元',
    );
  }
  // ====== 第5步：计算总价 ======
  // 用循环计算所有商品的总价

  // TODO: 计算并打印总价
  double total = 0.0;
  for (MapEntry<String, int> item in cart.entries) {
    total += ((priceList[item.key] ?? 0.0) * item.value);
  }
  print('总价: ${total.toStringAsFixed(2)}元');

  // ====== 第6步：折扣计算 ======
  // 满 50 元打 9 折，满 100 元打 8 折，满 200 元打 7 折
  // 写一个函数 double calcDiscount(double total) 返回折扣后的金额

  // TODO: 实现 calcDiscount 函数
  double calcDiscount(double total) {
    double result = total;
    switch (total) {
      case >= 200:
        result = total * 0.7;
      case >= 100:
        result = total * 0.8;
      case >= 50:
        result = total * 0.9;
    }
    return result;
  }

  double finalPrice = calcDiscount(total);
  print('折扣后: ${finalPrice.toStringAsFixed(2)}元');
  print('省了: ${(total - finalPrice).toStringAsFixed(2)}元');

  // ====== 第7步：找零计算 ======
  // 模拟顾客付了 100 元，计算应找零金额
  // 用三元运算符判断是否够付

  // TODO: 实现找零计算
  double paid = 100.0;
  double change = 0.0;
  String changeMsg = '';
  if (finalPrice > paid) {
    changeMsg = '老板,还差${finalPrice - paid}';
  } else {
    changeMsg = '找您${paid - finalPrice}元';
  }
  print(changeMsg);

  // ====== 第8步：购买最多的商品 ======
  // 遍历 cart，找出购买数量最多的商品

  // TODO: 找出购买最多的商品
  String maxItem = '';
  int maxQty = 0;

  print('购买最多的商品: $maxItem（${maxQty}件）');

  print('\n========== 结算完成 ==========');
}
