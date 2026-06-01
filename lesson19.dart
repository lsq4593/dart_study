// Dart 第十九课：泛型

void main() {
  // 泛型就是 "类型参数"，想放什么类型提前指定
  var box = Box<int>(123);
  print(box.getValue());

  var box2 = Box<String>('你好');
  print(box2.getValue());

  // 多个参数
  var pair = Pair('name', '小明');
  print('${pair.first}: ${pair.second}');
}

// T 是类型参数，用的时候再确定具体类型
class Box<T> {
  T value;
  Box(this.value);

  T getValue() => value;
}

class Pair<K, V> {
  K first;
  V second;
  Pair(this.first, this.second);
}
