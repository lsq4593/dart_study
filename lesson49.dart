// Dart 第四十九课：正则表达式 (RegExp)

void main() {
  // ========== 1. 基本使用：是否匹配 ==========
  var phoneReg = RegExp(r'^1[3-9]\d{9}$');

  print('========== 1. hasMatch ==========');
  print('13812345678: ${phoneReg.hasMatch('13812345678')}');
  print('12345:      ${phoneReg.hasMatch('12345')}');
  print('abc:        ${phoneReg.hasMatch('abc')}');

  // ========== 2. 提取匹配结果 ==========
  var text = '我的电话是13812345678，备用机15987654321';
  var phoneReg2 = RegExp(r'1[3-9]\d{9}');

  print('\n========== 2. allMatches ==========');
  var matches = phoneReg2.allMatches(text);
  print('找到 ${matches.length} 个手机号:');
  for (var m in matches) {
    print('  ${m.group(0)} (位置: ${m.start}-${m.end})');
  }

  // // ========== 3. stringMatch ==========
  // print('\n========== 3. stringMatch ==========');
  // var first = phoneReg2.stringMatch(text);
  // print('第一个手机号: $first');

  // // ========== 4. 替换 ==========
  // print('\n========== 4. replaceAll ==========');
  // var input = 'abc123def456ghi';
  // var result = input.replaceAll(RegExp(r'\d+'), 'X');
  // print('替换数字: $result');

  // var msg = '请联系13812345678';
  // var hidden = msg.replaceAllMapped(phoneReg2, (m) {
  //   var phone = m.group(0)!;
  //   return '${phone.substring(0, 3)}****${phone.substring(7)}';
  // });
  // print('隐藏手机号: $hidden');

  // // ========== 5. 分组捕获 ==========
  // print('\n========== 5. 分组 ==========');

  // var dateReg = RegExp(r'(\d{4})-(\d{2})-(\d{2})');
  // var dateMatch = dateReg.firstMatch('今天是2026-06-03');
  // if (dateMatch != null) {
  //   print('完整匹配: ${dateMatch.group(0)}');
  //   print('年: ${dateMatch.group(1)}');
  //   print('月: ${dateMatch.group(2)}');
  //   print('日: ${dateMatch.group(3)}');
  // }

  // var emailReg = RegExp(r'(\w+)@(\w+\.\w+)');
  // var emailMatch = emailReg.firstMatch('我的邮箱是user@example.com');
  // if (emailMatch != null) {
  //   print('\n邮箱解析:');
  //   print('  完整: ${emailMatch.group(0)}');
  //   print('  用户名: ${emailMatch.group(1)}');
  //   print('  域名: ${emailMatch.group(2)}');
  // }

  // // ========== 6. 常用验证 ==========
  // print('\n========== 6. 常用验证 ==========');

  // var emailCheck = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$');
  // void checkEmail(String s) =>
  //     print('  "$s" -> ${emailCheck.hasMatch(s) ? "OK" : "NO"}');

  // checkEmail('test@example.com');
  // checkEmail('user.name+tag@company.co.jp');
  // checkEmail('not-email');
  // checkEmail('@no-user.com');

  // var digitOnly = RegExp(r'^\d+$');
  // print('  "12345" 纯数字: ${digitOnly.hasMatch('12345')}');
  // print('  "12a45" 纯数字: ${digitOnly.hasMatch('12a45')}');

  // var urlReg = RegExp(r'^https?://[\w./-]+$');
  // print('  "https://example.com" URL: ${urlReg.hasMatch('https://example.com')}');
  // print('  "ftp://abc" URL: ${urlReg.hasMatch('ftp://abc')}');

  // // ========== 7. 提取所有数字 ==========
  // print('\n========== 7. 提取所有数字 ==========');
  // var mixed = '价格: 29.9元, 数量: 3个, 总计: 89.7元';
  // var numReg = RegExp(r'\d+(\.\d+)?');
  // var nums = numReg.allMatches(mixed).map((m) => m.group(0));
  // print('提取的数字: ${nums.join(', ')}');

  // // ========== 8. split 分隔 ==========
  // print('\n========== 8. RegExp split ==========');
  // var csv = 'a,b;c|d';
  // var parts = csv.split(RegExp(r'[,;|]'));
  // print('按 ,;| 分隔: $parts');

  // // ========== 9. 贪婪 vs 非贪婪 ==========
  // print('\n========== 9. 贪婪 vs 非贪婪 ==========');
  // var html = '<div>A</div><div>B</div>';

  // var greedy = RegExp(r'<div>.*</div>');
  // print('贪婪匹配: ${greedy.stringMatch(html)}');

  // var nonGreedy = RegExp(r'<div>.*?</div>');
  // print('非贪婪匹配: ${nonGreedy.stringMatch(html)}');

  // // ========== 10. 多行模式 ==========
  // print('\n========== 10. 多行模式 ==========');
  // var multiline = 'line1\nline2\nline3';

  // var defaultReg = RegExp(r'^\w+$');
  // print('默认模式: ${defaultReg.hasMatch(multiline)}');

  // var multiReg = RegExp(r'^\w+$', multiLine: true);
  // print('多行模式: ${multiReg.allMatches(multiline).length} 行匹配');
  // for (var m in multiReg.allMatches(multiline)) {
  //   print('  -> ${m.group(0)}');
  // }

  // // ========== 11. 忽略大小写 ==========
  // print('\n========== 11. 忽略大小写 ==========');
  // var caseReg = RegExp(r'hello', caseSensitive: false);
  // print('Hello: ${caseReg.hasMatch('Hello')}');
  // print('HELLO: ${caseReg.hasMatch('HELLO')}');
  // print('hello: ${caseReg.hasMatch('hello')}');
  // print('world: ${caseReg.hasMatch('world')}');
}
