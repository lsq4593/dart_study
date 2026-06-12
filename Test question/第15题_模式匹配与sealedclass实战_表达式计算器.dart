// Dart 全课程综合练习题 — 第15题
// 知识点：switch表达式、sealed class、模式匹配、Record

// TODO: 用 sealed class 定义表达式类型
// sealed class Expr {}
// class Num extends Expr { final num value; }
// class Add extends Expr { final Expr left, right; }
// class Subtract extends Expr { final Expr left, right; }
// class Multiply extends Expr { final Expr left, right; }
// class Divide extends Expr { final Expr left, right; }

// 1. 实现 num evaluate(Expr expr) 函数，用 switch 表达式计算
// 2. 实现 String toExprString(Expr expr) 函数，转成字符串表达 (如 "(1+2)*3")
// 3. 用 if-case 判断一个表达式是否只包含数字（没有运算符）
// 4. 用 Record 返回 (result, expressionString)

// TODO: 实现

void main() {
  // 表达式: (1 + 2) * 3 - 4 / 2
  var expr = Subtract(
    Multiply(
      Add(Num(1), Num(2)),
      Num(3),
    ),
    Divide(Num(4), Num(2)),
  );
  
  // 计算
  var result = evaluate(expr);
  print('计算结果: $result'); // 期望: 7
  
  // 表达式字符串
  var exprStr = toExprString(expr);
  print('表达式: $exprStr'); // 期望: ((1 + 2) * 3) - (4 / 2)
  
  // 判断是否纯数字
  print('是否纯数字: ${isPureNumber(expr)}'); // false
  print('是否纯数字: ${isPureNumber(Num(5))}'); // true
  
  // 用 Record 同时返回结果和表达式
  var (res, str) = evaluateWithString(expr);
  print('$str = $res');
}
