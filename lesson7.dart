// Dart 第七课：函数

void main() {
  sayHello('小明');
  int result = add(5, 3);
  print('5 + 3 = $result');
  print('平方: ${square(4)}');
}

// 无返回值
void sayHello(String name) {
  print('你好, $name!');
}

// 有返回值
int add(int a, int b) {
  return a + b;
}

// 箭头函数（简写）
int square(int n) => n * n;
