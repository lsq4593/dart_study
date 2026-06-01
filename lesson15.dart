// Dart 第十五课：级联运算符 ..

void main() {
  // 不用级联
  var list1 = <int>[];
  list1.add(1);
  list1.add(2);
  list1.add(3);
  print(list1);

  // 用级联 .. 连续操作同一个对象
  var list2 = <int>[]
    ..add(1)
    ..add(2)
    ..add(3);
  print(list2);

  // 实际应用：配置对象
  var sb = StringBuffer()
    ..write('Hello')
    ..write(' ')
    ..write('Dart');
  print(sb.toString());
}
