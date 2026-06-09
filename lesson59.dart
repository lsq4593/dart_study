// Dart 第五十九课：StringBuffer 高效字符串拼接

void main() {
  print('========== StringBuffer ==========');

  // ========== 1. 基本用法 ==========
  print('\n--- 1. 基本 ---');
  var sb = StringBuffer();
  sb.write('Hello');
  sb.write(' ');
  sb.write('Dart');
  sb.write('!');
  print(sb); // Hello Dart!

  // ========== 2. writeln 换行 ==========
  print('\n--- 2. writeln 换行 ---');
  var sb2 = StringBuffer();
  sb2.writeln('第一行');
  sb2.writeln('第二行');
  sb2.writeln('第三行');
  print(sb2.toString());

  // ========== 3. writeAll 批量添加 ==========
  print('\n--- 3. writeAll ---');
  var sb3 = StringBuffer();
  sb3.writeAll(['苹果', '香蕉', '西瓜']);
  print('无分隔符: ${sb3.toString()}');

  var sb4 = StringBuffer();
  sb4.writeAll(['苹果', '香蕉', '西瓜'], '、');
  print('有分隔符: ${sb4.toString()}');

  // ========== 4. clear / length / isEmpty ==========
  print('\n--- 4. 管理 ---');
  var sb5 = StringBuffer();
  print('创建后 isEmpty: ${sb5.isEmpty}');

  sb5.write('临时内容');
  print('写入后: ${sb5.toString()}');
  print('长度: ${sb5.length}');

  sb5.clear();
  print('clear后 isEmpty: ${sb5.isEmpty}');

  // ========== 5. 性能对比 ==========
  print('\n--- 5. 性能对比 ---');

  // 用 + 拼接
  var sw1 = Stopwatch()..start();
  var s1 = '';
  for (int i = 0; i < 50000; i++) {
    s1 += '第$i行\n';
  }
  sw1.stop();
  print('用 + 拼接: ${sw1.elapsedMilliseconds}ms (长度: ${s1.length})');

  // 用 StringBuffer
  var sw2 = Stopwatch()..start();
  var sb6 = StringBuffer();
  for (int i = 0; i < 50000; i++) {
    sb6.writeln('第$i行');
  }
  var s2 = sb6.toString();
  sw2.stop();
  print('用 StringBuffer: ${sw2.elapsedMilliseconds}ms (长度: ${s2.length})');

  // ========== 6. 实际场景：生成 CSV ==========
  print('\n--- 6. 生成 CSV ---');
  var csv = StringBuffer();
  csv.writeln('姓名,年龄,城市');
  csv.writeln('小明,25,北京');
  csv.writeln('小红,22,上海');
  csv.writeln('小刚,28,广州');
  print(csv.toString());

  // ========== 7. 实际场景：拼接 HTML ==========
  print('\n--- 7. 拼接 HTML ---');
  var html = StringBuffer();
  html.writeln('<ul>');
  for (var item in ['首页', '关于', '联系']) {
    html.writeln('  <li>$item</li>');
  }
  html.writeln('</ul>');
  print(html.toString());

  // ========== 8. 实际场景：构建查询语句 ==========
  print('\n--- 8. 构建查询参数 ---');
  String buildQuery(Map<String, String> params) {
    var sb = StringBuffer();
    bool first = true;
    for (var entry in params.entries) {
      if (!first) sb.write('&');
      sb.write('${Uri.encodeComponent(entry.key)}');
      sb.write('=');
      sb.write('${Uri.encodeComponent(entry.value)}');
      first = false;
    }
    return sb.toString();
  }

  var query = buildQuery({
    'name': 'dart language',
    'page': '1',
    'sort': 'desc',
  });
  print('查询字符串: $query');

  // ========== 9. StringBuffer 嵌套 ==========
  print('\n--- 9. StringBuffer 嵌套 ---');
  var outer = StringBuffer();
  outer.writeln('开始');

  var inner = StringBuffer();
  inner.writeln('  内层内容1');
  inner.writeln('  内层内容2');

  outer.write(inner.toString()); // 把 inner 的结果写入 outer
  outer.writeln('结束');

  print(outer.toString());

  print('\n程序结束');
}

/*
总结：StringBuffer

1. 方法
   write(str)          → 追加
   writeln(str)        → 追加并换行
   writeAll(list)      → 追加列表所有元素
   writeAll(list, sep) → 用分隔符连接列表
   clear()             → 清空
   toString()          → 取出结果

2. 属性
   length              → 字符数
   isEmpty             → 是否为空
   isNotEmpty          → 是否不为空

3. 什么时候用
   循环拼接（超过5次） → 用 StringBuffer
   少量拼接（3-5次）   → 用 + 就行

4. 为什么快
   + 每次创建新字符串，复制全部字符
   StringBuffer 用内部缓冲区，最后一次生成
*/
