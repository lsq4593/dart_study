// Dart 练习题 — 第1题 拓展⑤：水果库存管理
// 知识点：变量、Map、函数、循环、条件判断、三元运算符、字符串插值
//
// 实现一个水果库存管理系统，支持入库、出库、盘点和预警。

void main() {
  print('========== 水果库存管理 ==========\n');

  // ====== 第1步：初始化库存 ======
  // 创建一个 Map<String, int> 存储水果名称和库存数量
  // 至少包含 6 种水果

  // TODO: 创建 inventory Map
  Map<String, int> inventory = {
    '苹果': 50,
    '香蕉': 30,
    '草莓': 20,
    '葡萄': 15,
    '橙子': 40,
    '西瓜': 5,
  };

  // ====== 第2步：打印库存 ======
  // 写一个函数 void printInventory(Map<String, int> inventory)
  // 打印所有水果的库存情况
  // 格式: "苹果: 50个"

  // TODO: 实现 printInventory 函数
  void printInventory(Map<String, int> inventory) {
    for (var entry in inventory.entries) {
      print('  ${entry.key}: ${entry.value}个');
    }
  }

  print('--- 当前库存 ---');
  printInventory(inventory);

  // ====== 第3步：入库操作 ======
  // 写一个函数 void stockIn(Map<String, int> inventory, String fruit, int qty)
  // 增加某种水果的库存数量
  // 如果水果不存在，自动添加到库存中

  // TODO: 实现 stockIn 函数
  void stockIn(Map<String, int> inventory, String fruit, int qty) {
    inventory[fruit] = (inventory[fruit] ?? 0) + qty;
    print('  入库 $fruit $qty 个');
  }

  print('\n--- 入库操作 ---');
  stockIn(inventory, '苹果', 20);
  stockIn(inventory, '荔枝', 10);

  // ====== 第4步：出库操作 ======
  // 写一个函数 bool stockOut(Map<String, int> inventory, String fruit, int qty)
  // 减少某种水果的库存数量
  // 如果库存不足，返回 false 并打印提示
  // 如果水果不存在，返回 false
  // 成功返回 true

  // TODO: 实现 stockOut 函数
  bool stockOut(Map<String, int> inventory, String fruit, int qty) {
    if (!inventory.containsKey(fruit)) {
      print('  ❌ $fruit 不存在');
      return false;
    }
    if (inventory[fruit]! < qty) {
      print('  ❌ $fruit 库存不足（当前: ${inventory[fruit]}个，需要: $qty个）');
      return false;
    }
    inventory[fruit] = inventory[fruit]! - qty;
    print('  出库 $fruit $qty 个');
    return true;
  }

  print('\n--- 出库操作 ---');
  bool out1 = stockOut(inventory, '苹果', 10);
  print('出库苹果10个: ${out1 ? '成功 ✅' : '失败 ❌'}');
  bool out2 = stockOut(inventory, '西瓜', 10); // 可能库存不足
  print('出库西瓜10个: ${out2 ? '成功 ✅' : '失败 ❌'}');
  bool out3 = stockOut(inventory, '榴莲', 5);  // 不存在
  print('出库榴莲5个: ${out3 ? '成功 ✅' : '失败 ❌'}');

  // ====== 第5步：库存预警 ======
  // 写一个函数 List<String> lowStockItems(Map<String, int> inventory, int threshold)
  // 返回库存低于阈值的水果名称列表

  // TODO: 实现 lowStockItems 函数
  List<String> lowStockItems(Map<String, int> inventory, int threshold) {
    List<String> lowItems = [];
    for (var entry in inventory.entries) {
      if (entry.value < threshold) {
        lowItems.add(entry.key);
      }
    }
    return lowItems;
  }

  print('\n--- 库存预警（低于 20 个） ---');
  int threshold = 20;
  var lowItems = lowStockItems(inventory, threshold);
  if (lowItems.isEmpty) {
    print('  所有水果库存充足 ✅');
  } else {
    print('  以下水果库存不足（< $threshold 个）:');
    for (var item in lowItems) {
      print('    ⚠️  $item（仅剩 ${inventory[item]} 个）');
    }
  }

  // ====== 第6步：盘点 ======
  // 写一个函数 int totalStock(Map<String, int> inventory)
  // 计算库存总量（所有水果数量之和）

  // TODO: 实现 totalStock 函数
  int totalStock(Map<String, int> inventory) {
    int total = 0;
    for (var qty in inventory.values) {
      total += qty;
    }
    return total;
  }

  print('\n--- 盘点 ---');
  int total = totalStock(inventory);
  int kinds = inventory.length;
  print('  水果种类: $kinds 种');
  print('  库存总量: $total 个');

  // ====== 第7步：找最多/最少库存的水果 ======
  // 遍历 inventory，找出库存最多和最最少的水果

  // TODO: 找出最多和最少
  String maxFruit = '';
  String minFruit = '';
  int maxQty = 0;
  int minQty = 999999;

  for (var entry in inventory.entries) {
    if (entry.value > maxQty) {
      maxQty = entry.value;
      maxFruit = entry.key;
    }
    if (entry.value < minQty) {
      minQty = entry.value;
      minFruit = entry.key;
    }
  }

  print('\n--- 统计 ---');
  print('  库存最多: $maxFruit（${maxQty}个）');
  print('  库存最少: $minFruit（${minQty}个）');

  // ====== 第8步：打印最终库存 ======
  print('\n--- 最终库存 ---');
  printInventory(inventory);

  print('\n========== 盘点完成 ==========');
}
