// Dart 第八课：List 列表

void main() {
  // 创建 List
  List<String> fruits = ['苹果', '香蕉', '西瓜'];
  // 访问
  print(fruits[0]);       // 苹果
  print(fruits.length);   // 3

  // 修改
  fruits.add('葡萄');     // 添加
  fruits.remove('香蕉');  // 删除
  print(fruits);

  // 遍历
  for (var f in fruits) {
    print('水果: $f');
  }
}
