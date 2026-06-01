// Dart 第六课：循环

void main() {
  // for 循环
  for (int i = 1; i <= 5; i++) {
    print('第$i次');
  }

  // while 循环
  int count = 3;
  while (count > 0) {
    print('倒计时: $count');
    count--;
  }

  // for-in 遍历
  var fruits = ['苹果', '香蕉', '西瓜'];
  for (var fruit in fruits) {
    print(fruit);
  }
}
