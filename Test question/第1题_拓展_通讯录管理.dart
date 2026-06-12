// Dart 练习题 — 第1题 拓展③：通讯录管理
// 知识点：变量、List、Map、函数、循环、条件判断、字符串插值
//
// 实现一个简单的通讯录管理系统，支持增删改查联系人。

void main() {
  print('========== 通讯录管理 ==========\n');

  // ====== 第1步：初始化通讯录 ======
  // 创建一个 List<Map<String, String>> 存储联系人
  // 每个联系人包含 name、phone、email 三个字段
  // 至少预置 4 个联系人

  // TODO: 创建 contacts 列表
  List<Map<String, String>> contacts = [];

  // ====== 第2步：打印通讯录 ======
  // 写一个函数 void printContacts(List<Map<String, String>> contacts)
  // 打印所有联系人的姓名、电话和邮箱
  // 格式：序号. 姓名 | 电话: xxx | 邮箱: xxx

  // TODO: 实现 printContacts 函数
  void printContacts(List<Map<String, String>> contacts) {
    // 你的代码
  }

  print('--- 当前通讯录 ---');
  printContacts(contacts);

  // ====== 第3步：添加联系人 ======
  // 写一个函数 void addContact(List<Map<String, String>> contacts, String name, String phone, String email)
  // 把新的联系人添加到通讯录中

  // TODO: 实现 addContact 函数
  void addContact(List<Map<String, String>> contacts, String name, String phone, String email) {
    // 你的代码
  }

  print('\n--- 添加联系人 ---');
  // 添加小文和小强

  // ====== 第4步：按姓名搜索 ======
  // 写一个函数 List<Map<String, String>> searchByName(List<Map<String, String>> contacts, String keyword)
  // 返回姓名中包含关键字的所有联系人

  // TODO: 实现 searchByName 函数
  List<Map<String, String>> searchByName(List<Map<String, String>> contacts, String keyword) {
    return []; // 替换这行
  }

  print('\n--- 搜索联系人 (关键字: 小) ---');
  var results = searchByName(contacts, '小');
  for (var c in results) {
    print('  ${c['name']} - ${c['phone']}');
  }

  // ====== 第5步：删除联系人 ======
  // 写一个函数 bool removeContact(List<Map<String, String>> contacts, String name)
  // 删除指定姓名的联系人，删除成功返回 true，没找到返回 false

  // TODO: 实现 removeContact 函数
  bool removeContact(List<Map<String, String>> contacts, String name) {
    return false; // 替换这行
  }

  print('\n--- 删除联系人 ---');
  bool removed = removeContact(contacts, '小刚');
  print('删除小刚: ${removed ? '成功 ✅' : '失败 ❌'}');
  bool removed2 = removeContact(contacts, '不存在的人');
  print('删除不存在的人: ${removed2 ? '成功 ✅' : '失败 ❌'}');

  // ====== 第6步：更新联系人 ======
  // 写一个函数 bool updateContact(List<Map<String, String>> contacts, String name, {String? newPhone, String? newEmail})
  // 更新指定联系人的电话或邮箱，更新成功返回 true

  // TODO: 实现 updateContact 函数
  bool updateContact(List<Map<String, String>> contacts, String name, {String? newPhone, String? newEmail}) {
    return false; // 替换这行
  }

  print('\n--- 更新联系人 ---');
  bool updated = updateContact(contacts, '小明', newPhone: '13900000001');
  print('更新小明电话: ${updated ? '成功 ✅' : '失败 ❌'}');

  // ====== 第7步：统计通讯录 ======
  // 计算通讯录中联系人的总数
  // 用三元运算符打印"有 X 位联系人"或"通讯录为空"

  // TODO: 统计并打印
  int count = 0;
  String msg = '';
  print('\n--- 统计 ---');
  print(msg);

  // ====== 第8步：打印最终通讯录 ======
  print('\n--- 最终通讯录 ---');
  printContacts(contacts);

  print('\n========== 管理完成 ==========');
}
