// Dart 第四十三课：if-case 模式匹配

void main() {
  var point = (4, 4);

  // if-case：只匹配一种模式，不用写完整 switch
  if (point case (int x, int y)) {
    print('坐标: ($x, $y)');
  }

  // 带 when 守卫条件
  if (point case (int x, int y) when x == y) {
    print('在对角线上');
  } else {
    print('不在对角线上');
  }

  // 空值检查
  String? name = '小红';
  if (name case var n?) {
    print('名字: $n');
  }
}

/*
对比：switch 表达式 vs if-case

| | switch 表达式 | if-case |
|---|---|---|
| 分支数 | 多个 | 一个（+else）|
| 穷尽性 | ✅ 强制 | ❌ 不需要 |
| 适合 | 需要处理所有情况 | 只关心一种模式 |
*/
