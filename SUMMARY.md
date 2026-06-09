# Dart 基础知识点总结

---

## 第1课：第一个程序

```dart
void main() {
  print('Hello, Dart!');
}
```

**用法：**
- `void main()` — 每个 Dart 程序必须有，程序从这里开始执行
- `print(内容)` — 在控制台输出文本，括号里可以是字符串、数字、变量等
- 每条语句以 `;` 结尾

---

## 第2课：变量

```dart
var name = '小明';      // 类型推断 → String
int age = 25;            // 整数
double height = 1.75;    // 浮点数（小数）
String greeting = '你好'; // 字符串
bool isStudent = true;   // 布尔值（true/false）
```

**用法：**
- `var` — 自动推断类型，省去写类型名
  ```dart
  var x = 10;     // Dart 自动推断为 int
  var y = 'abc';  // Dart 自动推断为 String
  ```
- 显式指定类型 — 明确意图，方便阅读
  ```dart
  int age = 25;
  double price = 19.9;
  ```
- 字符串插值
  ```dart
  print('我叫$name, $age岁');
  print('面积: $width * $height = ${width * height}');  // 表达式加 {}
  ```

**对比：`var` vs 显式类型**

| | var | 显式类型 |
|---|---|---|
| 写法 | `var x = 10;` | `int x = 10;` |
| 效果 | 完全一样 | 完全一样 |
| 适合 | 类型一目了然时（`var name = '小明'`） | 想强调类型时（`int age = 25`） |

---

## 第3课：常量 final 和 const

```dart
final String name = '小明';
final now = DateTime.now();   // 运行时确定，之后不能改

const double pi = 3.14159;
const hoursInDay = 24;        // 编译时就确定
```

**对比：`final` vs `const` vs 普通变量 `var`**

| | var | final | const |
|---|---|---|---|
| 赋值后能改？ | ✅ 可以 | ❌ 不能 | ❌ 不能 |
| 何时确定值 | 运行时 | 运行时（只赋值一次） | **编译时** |
| 适用场景 | 需要修改的变量 | 只赋值一次，如当前时间 | 永远不变，如圆周率 |

**错误示例：**
```dart
const x = DateTime.now();  // ❌ 编译报错！DateTime.now() 运行时才知道
final y = DateTime.now();   // ✅ 正确
```

---

## 第4课：运算符

**用法：**
```dart
// 算术
print(10 + 3);   // 13
print(10 - 3);   // 7
print(10 * 3);   // 30
print(10 / 3);   // 3.333...（结果是 double）
print(10 ~/ 3);  // 3（取整除法，丢掉小数）
print(10 % 3);   // 1（取余数）

// 比较 — 结果都是 bool
print(5 > 3);    // true
print(5 == 3);   // false
print(5 != 3);   // true

// 逻辑
bool a = true;
bool b = false;
print(a && b);  // false（且：都 true 才 true）
print(a || b);  // true（或：一个 true 就 true）
print(!a);      // false（非：取反）
```

**对比：`/` vs `~/`**
```dart
// / 保留小数（double）
print(7 / 2);   // 3.5

// ~/ 只取整数部分
print(7 ~/ 2);  // 3
```

---

## 第5课：条件判断 if / else

**用法：**
```dart
if (条件) {
  // 条件 true 执行
} else if (另一个条件) {
  // 另一个条件 true 执行
} else {
  // 都不满足执行
}
```

**实际场景：**
```dart
// 场景 1：判断成绩等级
int score = 85;
if (score >= 90) {
  print('优秀');
} else if (score >= 60) {
  print('及格');
} else {
  print('不及格');
}

// 场景 2：判断用户状态
bool isLoggedIn = true;
if (isLoggedIn) {
  print('显示个人中心');
} else {
  print('显示登录按钮');
}
```

**三元运算符（简写 if-else）：**
```dart
// 完整写法
String result;
if (age >= 18) {
  result = '成年';
} else {
  result = '未成年';
}

// 等价三元写法
String result = age >= 18 ? '成年' : '未成年';
//            条件        true的值 : false的值
```

---

## 第6课：循环

**用法：**
```dart
// for — 知道循环次数
for (int i = 1; i <= 5; i++) {
  print(i);  // 1 2 3 4 5
}

// while — 条件控制，先判断再执行
int count = 3;
while (count > 0) {
  print(count);  // 3 2 1
  count--;
}

// for-in — 遍历集合最方便
var fruits = ['苹果', '香蕉', '西瓜'];
for (var fruit in fruits) {
  print(fruit);  // 苹果 香蕉 西瓜
}
```

**对比：三种循环怎么选**

| 循环 | 适用场景 | 例子 |
|------|----------|------|
| `for` | 知道要循环几次 | 循环 5 次、循环 10 次 |
| `while` | 不知道次数，满足条件才停 | 倒计时到 0 停止 |
| `for-in` | 遍历列表/集合中的每个元素 | 逐个打印水果 |

---

## 第7课：函数

**用法：**
```dart
// 无返回值
void greet(String name) {
  print('你好, $name');
}

// 有返回值 — 必须 return
int add(int a, int b) {
  return a + b;
}

// 箭头函数 — 只有一行时简写
int square(int n) => n * n;
// 等价于：int square(int n) { return n * n; }
```

**对比：普通函数 vs 箭头函数**

| | 普通函数 | 箭头函数 `=>` |
|---|---|---|
| 写法 | `int f(int x) { return x * 2; }` | `int f(int x) => x * 2;` |
| 能写几行 | 多行 | **只能一行** |
| 需要 return | 是 | 自动返回 `=>` 后面的表达式 |

---

## 第8课：List 列表

**用法：**
```dart
// 创建
List<String> fruits = ['苹果', '香蕉', '西瓜'];
var numbers = [1, 2, 3];  // 也可以不写类型

// 常用操作
fruits.add('葡萄');            // 添加
fruits.remove('香蕉');         // 删除
fruits.removeAt(1);            // 按索引删除
print(fruits[0]);              // 取第一个（索引从0开始）
print(fruits.length);          // 长度
print(fruits.contains('苹果')); // 是否包含 → true

// 遍历
for (var f in fruits) { print(f); }
fruits.forEach((f) => print(f));
```

**类比：** List 就像一个**有序的抽屉柜**，每个抽屉有编号（索引 0、1、2...），通过编号取东西。

---

## 第9课：Map 键值对

**用法：**
```dart
// 创建
Map<String, int> scores = {
  '语文': 90,
  '数学': 85,
};

// 操作
scores['物理'] = 88;          // 添加键值对
scores['数学'] = 95;          // 修改已有值
print(scores['数学']);         // 通过键取值 → 95
print(scores.length);          // 键值对数量

// 遍历 — 参数1=键，参数2=值
scores.forEach((subject, score) {
  print('$subject: $score 分');
});
```

**对比：List vs Map**

| | List | Map |
|---|---|---|
| 存储方式 | 有序排列 | 键值对 |
| 取值方式 | `list[索引]` | `map[键]` |
| 索引类型 | int（0, 1, 2...） | 任意类型（String、int...） |
| 适合场景 | 列表数据（水果清单） | 映射关系（科目→分数） |

---

## 第10课：类与对象

**用法：**
```dart
// 定义类
class Animal {
  String name;        // 属性
  int age;
  Animal(this.name, this.age); // 构造函数自动赋值
  void bark() { print('$name: 汪汪'); } // 方法
}

// 创建对象
var dog = Animal('旺财', 3);
print(dog.name);  // 访问属性
dog.bark();       // 调用方法
```

**`this` 关键字：** 指向当前对象，区分参数和属性
```dart
Animal(String name, int age) {
  this.name = name;  // this.name=属性，右边name=参数
  this.age = age;
}
// 简写：Animal(this.name, this.age);
```

---

## 第11课：命名参数与默认值

**用法：**
```dart
// 命名参数 { } — 调用时必须写参数名
String createUser({required String name, int age = 18}) {
  return '$name, $age 岁';
}
createUser(name: '小明', age: 25);  // 参数顺序随意

// 可选位置参数 [ ] — 按顺序传值
String sayHello(String name, [String greet = '你好']) {
  return '$greet, $name!';
}
sayHello('小明');              // 不传用默认值
sayHello('小明', '嗨');        // 传了就覆盖
```

**对比：三种参数**

| 参数类型 | 语法 | 调用方式 | 必传？ |
|----------|------|----------|--------|
| 普通参数 | `f(String name)` | `f('小明')` | 必须传 |
| 命名参数 | `f({String name})` | `f(name: '小明')` | 看是否有 `required` |
| 可选位置参数 | `f([String name])` | `f('小明')` 或 `f()` | 可传可不传 |

---

## 第12课：空安全

**用法：**
```dart
// ? — 声明变量可以为 null
String? name;       // 没赋值，默认 null
String  name;       // ❌ 编译错误，非空类型必须赋值

// ?? — 如果左边为 null，用右边的值
String? nickname;
print(nickname ?? '默认昵称');  // nickname 是 null → 输出"默认昵称"

// ?. — 如果左边为 null 就不执行，不崩溃
String? user;
print(user?.length);  // user 是 null → 不调 length，返回 null
print(user.length);   // ❌ 会崩溃！不能直接取 null 的属性
```

**为什么要空安全？**
```dart
// 没有空安全时，忘记了判断 null 就直接用，运行就崩溃
// 空安全让这种错误在编译时就暴露
String? name;   // 必须写 ? 表示允许 null
print(name.length);  // ❌ 编译器直接报错，不会等到运行
```

---

## 第13课：命名构造函数

**用法：**
```dart
class Person {
  String name;
  int age;

  Person(this.name, this.age);           // 普通构造函数

  Person.guest() : this('访客', 18);      // 固定值

  Person.fromBirthday(String name, int birthYear)
      : this(name, DateTime.now().year - birthYear);  // 计算后赋值
}

var p1 = Person('小明', 25);      // 普通
var p2 = Person.guest();         // 命名
var p3 = Person.fromBirthday('小红', 2000);  // 命名
```

**对比：普通 vs 命名构造函数**

| | 普通构造函数 | 命名构造函数 |
|---|---|---|
| 名称 | 必须和类名相同 | `类名.任意名字` |
| 数量 | 只能一个 | 多个 |
| 调用 | `Person('小明', 25)` | `Person.guest()` |

**`: this(...)` 初始化列表的作用：** 把命名构造函数的逻辑先处理完，再转发给另一个构造函数赋值。

---

## 第14课：继承

**用法：**
```dart
class Animal {
  String name;
  Animal(this.name);
  void sleep() { print('$name 睡觉了'); }
}

class Dog extends Animal {
  String color;
  Dog(String name, this.color) : super(name);
  void bark() { print('汪汪'); }
}

var dog = Dog('旺财', '棕色');
dog.sleep();  // 继承来的方法
dog.bark();   // 自己的方法
```

**对比：`extends` vs 不用继承**

| | 不用继承，每个类自己写 | 用继承 |
|---|---|---|
| 代码量 | 每个类都写一遍 sleep() | 父类写一次，子类复用 |
| 修改 | 要改多处 | 改父类一处就行 |
| 关系 | 类之间没联系 | 子类 is-a 父类 |

---

## 第15课：级联运算符 ..

**对比：不用 `..` vs 用 `..`**

```dart
// 不用级联 — 每次重复写变量名
var list = <int>[];
list.add(1);
list.add(2);
list.add(3);

// 用级联 — .. 表示"还在操作同一个对象"
var list = <int>[]
  ..add(1)
  ..add(2)
  ..add(3);
```

**本质：** `..` 左边的东西执行完后，**返回的还是左边那个对象本身**，所以能继续往后接。而普通 `.` 返回的是方法的返回值。

```dart
list.add(1)   // 返回 void，不能继续 .add(2)
list..add(1)  // 返回 list 本身，所以可以继续 ..add(2)
```

---

## 第16课：抽象类

**用法：**
```dart
abstract class Shape {
  double area();       // 抽象方法：无方法体，子类必须实现
  void draw() { }      // 普通方法：子类可直接用
}

class Circle extends Shape {
  double r;
  Circle(this.r);
  @override
  double area() => 3.14 * r * r;
}

Shape s = Circle(5);   // 抽象类不能 new，但可以声明为 Shape 类型
```

**对比：抽象类 vs 普通类**

| | 普通类 `class` | 抽象类 `abstract class` |
|---|---|---|
| 能 new？ | ✅ `Animal()` | ❌ `Shape()` 编译报错 |
| 能包含抽象方法？ | ❌ 不能 | ✅ 可以 |
| 用途 | 直接创建对象用 | 定义规范，当父类用 |

**`@override` 的作用：** 告诉 Dart 这个方法是故意重写父类的。不加也能重写，但加了可以防手误——如果父类根本没有这个方法，编译器会报错。

---

## 第17课：implements 接口

**用法：**
```dart
class Electronic {
  void turnOn() {}
}

class TV implements Electronic {
  @override
  void turnOn() { print('电视开机'); }
}
```

**对比：`extends` vs `implements`**

| | extends | implements |
|---|---|---|
| 复用代码 | ✅ 父类已实现的方法直接用 | ❌ 必须自己全写一遍 |
| 数量 | 只能 **一个** | 可以 **多个** |
| 关系 | 子类 **is-a** 父类（狗是动物） | 按**合同/规范**办事 |

**多 implements 示例：**
```dart
class A { void a() {} }
class B { void b() {} }
class C implements A, B {
  @override
  void a() { }  // A 的方法
  @override
  void b() { }  // B 的方法
}
```

---

## 第18课：Mixin 混入

**用法：**
```dart
mixin Runner  { void run()  => print('跑'); }
mixin Swimmer { void swim() => print('游'); }

class Animal { Animal(this.name); }
class Dog extends Animal with Runner, Swimmer { }
```

**对比：`extends` vs `implements` vs `with`**

| | extends | implements | with |
|---|---|---|---|
| 数量 | 一个 | 多个 | 多个 |
| 代码复用 | ✅ 直接继承实现 | ❌ 必须重写 | ✅ 直接使用 mixin 的方法 |
| 关系 | is-a（是什么） | 按合同办（遵守规范） | has-ability（有什么能力） |

**实际场景对比：**
```dart
// 你有一些类都需要"保存到数据库"的功能

// ❌ 继承 — 不自然
class DatabaseSaver {}
class User extends DatabaseSaver {}  // 用户"是"数据保存器？

// ✅ mixin — 自然
mixin Saveable { void save() => print('保存'); }
class User with Saveable {}           // 用户"有"保存能力
class Order with Saveable {}          // 订单"有"保存能力
```

---

## 第19课：泛型

**用法：**
```dart
// 泛型类 — T 是类型占位符
class Box<T> {
  T value;
  Box(this.value);
  T getValue() => value;
}

Box<int>(123);         // T = int
Box<String>('你好');    // T = String

// 泛型方法
T first<T>(List<T> list) => list[0];
print(first<int>([1, 2, 3]));    // 1
print(first(['a', 'b']));         // 自动推断
```

**对比：用泛型 vs 不用泛型**

```dart
// 不用泛型 — 用 dynamic
class Box {
  dynamic value;  // 可以存任何类型
}
Box box = Box();
box.value = 'abc';
int x = box.value;  // ❌ 运行时报错！String 不能当 int 用

// 用泛型 — 编译时就检查
Box<String> box = Box<String>();
box.value = 'abc';
int x = box.value;  // ❌ 编译报错，不会等到运行
```

**现有集合中的泛型：**
```dart
List<String>      // 只能存 String
List<int>         // 只能存 int
Map<String, int>  // 键是 String，值是 int
```

---

## 第20课：枚举

**用法：**
```dart
// 定义
enum Weekday { mon, tue, wed, thu, fri, sat, sun }

// 使用
var today = Weekday.wed;
print(today.name);   // "wed" — 枚举值的名称字符串
print(today.index);  // 2 — 位置序号（从0开始）

// switch 全覆盖
switch (today) {
  case Weekday.sat:
  case Weekday.sun:
    print('休息');
    break;
  default:
    print('工作日');
}
```

**对比：用枚举 vs 不用枚举**

```dart
// 不用枚举 — 魔法字符串，容易拼错
String status = 'pending';
if (status == 'pendding') { }  // 拼错了也不报错

// 用枚举 — 只能选定义好的值
enum OrderStatus { pending, paid, shipped, delivered }
OrderStatus status = OrderStatus.pending;
// 写 OrderStatus.pendding 直接编译报错
```

**对比：枚举 vs 普通类常量**

| | 枚举 `enum` | 类常量 `static const` |
|---|---|---|
| 写法 | `Weekday.mon` | `Constants.MON` |
| switch 全覆盖检查 | ✅ 编译器会检查是否漏了某个值 | ❌ 不会检查 |
| 自动补全 | ✅ 编辑器会提示所有值 | 要看常量类定义 |

---

## 第21课：异步 async / await

```dart
void main() async {              // async 标记异步函数
  String data = await fetchData(); // await 等待 Future 完成
}

Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));  // 模拟耗时
  return '数据加载完成';
}
```

**用法：**
- `async` — 标记函数是异步的
- `await` — 等待 Future 完成，**不阻塞**主线程
- `Future<T>` — 表示"将来会返回一个 T 类型的值"

**对比：同步 vs 异步**

```dart
// 同步 — 卡住等
var data = fetchData();  // 等好久，啥也干不了

// 异步 — 不阻塞
var future = fetchData(); // 先干别的
var data = await future;  // 等好了再拿结果
```

---

## 第22课：Stream 流

```dart
Stream<int> countDown(int from) async* {  // async* 标记 Stream
  for (int i = from; i > 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;  // yield 可多次返回值
  }
}

await for (int n in countDown(3)) {  // await for 接收 Stream
  print(n);
}
```

**对比：Future vs Stream**

| | Future | Stream |
|---|---|---|
| 返回次数 | 一次 | 多次 |
| 返回语法 | `return` | `yield` |
| 接收方式 | `await future` | `await for` |
| 比喻 | 等一个快递 | 看直播，数据一段段来 |

---

## 第23课：异常处理 try / catch

```dart
try {
  var data = await fetchData();
  print(data);
} catch (e) {
  print('出错了: $e');  // 出错不崩溃
}
print('程序继续');  // 不管是否出错，都继续执行
```

**对比：有 try-catch vs 没有**

| | 没有 try-catch | 有 try-catch |
|---|---|---|
| 出错时 | 程序崩溃 | 进 catch 分支，继续运行 |
| 适用场景 | 确定不会出错的代码 | 网络请求、文件读写等可能失败的操作 |

---

## 第24课：Extension 扩展方法

```dart
extension StringExt on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

extension IntExt on int {
  int get minutes => this * 60;
}

'hello'.capitalize();  // Hello
5.minutes;             // 300
```

**为什么需要 extension？** 不能修改 String、int 等已有类型的源码，但 extension 可以给它们加新方法，不用写工具函数。

---

## 第25课：Record 记录

```dart
// 位置 Record — $1, $2 取值
var user = ('小明', 25);
print(user.$1);  // 小明

// 命名 Record — 名字取值
var student = (name: '小红', score: 92);
print(student.name);

// 函数返回多个值
(int, int) divide(int a, int b) => (a ~/ b, a % b);
```

**对比：Record vs 类 vs Map**

| | Record | 类 class | Map |
|---|---|---|---|
| 要定义吗？ | ❌ 不用 | ✅ 要写 class | ❌ 不用 |
| 类型安全 | ✅ | ✅ | ❌ |
| 适合场景 | 函数返回多个临时值 | 业务实体 | 动态数据（JSON） |

---

## 第26课：sealed class 密封类

```dart
sealed class Result {}  // 子类只能在这里定义

class Success extends Result { final String data; Success(this.data); }
class Loading extends Result {}
class Error extends Result { final String message; Error(this.message); }

void check(Result r) {
  switch (r) {      // 必须覆盖所有子类，漏一个编译报错
    case Success(:var data): print('成功: $data');
    case Loading():           print('加载中');
    case Error(:var message): print('失败: $message');
  }
}
```

**对比：sealed class vs 普通抽象类**

| | 普通抽象类 | sealed class |
|---|---|---|
| switch 检查 | ❌ 不会检查全覆盖 | ✅ 漏掉子类编译报错 |
| 子类范围 | 任何文件都能继承 | **只能本文件内定义** |
| 适合场景 | 普通继承 | 状态管理（加载中/成功/失败） |

---

## 第27课：集合常用方法

```dart
var nums = [1, 2, 3, 4, 5, 6];

nums.where((n) => n.isEven);   // (2, 4, 6)  过滤
nums.map((n) => n * n);        // (1, 4, 9...) 转换
nums.any((n) => n > 5);        // true 有符合条件的吗
nums.every((n) => n > 0);      // true 全都符合吗
nums.firstWhere((n) => n > 3); // 4 第一个匹配的
nums.reduce((a, b) => a + b);  // 21 累加
```

这些方法都不会修改原集合，返回 `Iterable`（打印显示圆括号）。加 `.toList()` 转成 `List`（方括号）。

---

## 第28课：factory 工厂构造函数

```dart
class Config {
  static final _cache = <String, Config>{};

  factory Config(String host) {       // factory：不一定创建新对象
    if (_cache.containsKey(host)) {
      return _cache[host]!;            // 返回缓存对象
    }
    return Config._internal(host);     // 没有缓存才新建
  }

  Config._internal(this.host);        // 私有构造函数，外部不能调
}
```

**对比：普通 vs factory**

| | 普通构造函数 | factory 构造函数 |
|---|---|---|
| 每次新建对象？ | ✅ 是 | ❌ 可返回已有对象 |
| 能返回子类？ | ❌ | ✅ |
| 访问 this？ | ✅ | ❌ |
| 场景 | 普通对象 | 单例、缓存、对象池 |

---

## 第29课：static 静态成员

```dart
class Calculator {
  static const double pi = 3.14159;  // 属于类
  static int add(int a, int b) => a + b;

  int count = 0;  // 属于对象
}

Calculator.pi;      // ✅ 类名直接调
Calculator.add(1, 2); // ✅ 不用创建对象

var c = Calculator();
c.count;  // 非静态：必须通过对象调
```

**对比：static 成员 vs 普通成员**

| | static | 普通成员 |
|---|---|---|
| 属于谁 | 类本身 | 每个对象 |
| 调用方式 | `类名.成员` | `对象.成员` |
| 需要创建对象？ | ❌ 不用 | ✅ 必须 |
| 内存 | 一份共享 | 每对象各一份 |

---

## 第30课：getter 和 setter

```dart
class Rectangle {
  double width, height;
  Rectangle(this.width, this.height);

  double get area => width * height;         // getter：像属性一样读
  set area(double v) { width = v / height; } // setter：像属性一样写
}

var r = Rectangle(5, 3);
print(r.area);    // 15 — 调 getter
r.area = 30;      // 调 setter，自动调整 width
```

**对比：getter vs 普通方法**

| | getter | 普通方法 |
|---|---|---|
| 调用 | `r.area` | `r.area()` |
| 语义 | 像属性（名词） | 像动作（动词） |
| 有无参数 | 无 | 可以有 |
| 适合 | 计算属性、暴露私有字段 | 需要参数的操作 |

---

## 第31课：late 延迟初始化

```dart
class Report {
  late String data = _loadBigData();  // 用到才初始化
}

var r = Report(); // 创建时不加载
print(r.data);    // 第一次用时才调 _loadBigData()
```

执行顺序：
```
创建对象          ← data 没初始化
第一次访问 data   ← 才执行 _loadBigData()
```

**对比：普通 vs late**

| | 普通属性 | late 属性 |
|---|---|---|
| 初始化时机 | 创建对象时 | **第一次访问时** |
| 用不到会初始化吗？ | ✅ 会 | ❌ 不会 |
| 适合场景 | 简单值 | 初始化耗时、可能用不上 |

---

## 第32课：assert 断言

```dart
String createUser(String name, int age) {
  assert(name.isNotEmpty, '名字不能为空');  // 调试时检查
  assert(age >= 0, '年龄不能为负');
  return '$name, $age岁';
}
```

运行需加 `--enable-asserts`：
```bash
dart run --enable-asserts 文件.dart
```

**对比：assert vs if-throw**

| | assert | if + throw |
|---|---|---|
| 生效范围 | **调试模式**（需 `--enable-asserts`） | 调试+生产 |
| 性能影响 | 生产环境零开销 | 每次判断 |
| 适合场景 | 检查"不应该发生"的 bug | 外部输入校验 |

---

## 第33课：模式匹配解构

```dart
// 解构 List
var [a, b, c] = [1, 2, 3];

// 解构 Map
var {'name': name, 'age': age} = {'name': '小明', 'age': 25};

// 解构 Record
var (name2, age2) = ('小红', 24);

// 解构对象
var Point(:x, :y) = Point(3, 4);
```

**注意：** Map 解构必须写 `'键': 变量名`，不能像 Record 那样简写。因为 Map 的键是运行时字符串，Record 的字段名是编译时标识符。

---

## 第34课：运算符重载

```dart
class Point {
  final int x, y;
  const Point(this.x, this.y);

  Point operator +(Point other) => Point(x + other.x, y + other.y);
  Point operator -(Point other) => Point(x - other.x, y - other.y);

  @override
  bool operator ==(Object other) {
    return other is Point && x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}

Point(1, 2) + Point(3, 4);  // Point(4, 6)
```

重写 `==` 时必须同时重写 `hashCode`，否则 Set/Map 去重会出问题。

---

## 第35课：typedef 类型别名

```dart
typedef Filter = bool Function(int age);

Filter isAdult = (int age) => age >= 18;
isAdult(25); // true

// 复杂场景
typedef OnValueChanged<T> = void Function(T value);

class Input {
  OnValueChanged<String>? onChange;  // 比写完整函数签名清晰
}
```

**不用 typedef：** 每次写 `bool Function(int age)`，又长又难读
**用 typedef：** `Filter`，名字就说明了用途

---

## 第36课：callable class 可调用的类

```dart
class Adder {
  final int n;
  Adder(this.n);
  int call(int x) => x + n;  // call 方法让对象可调用
}

var add5 = Adder(5);  // "记住"5
add5(10);             // 15，像函数一样
add5(20);             // 25
```

**对比：callable class vs 普通函数**

| | 普通函数 | callable class |
|---|---|---|
| 携带状态 | ❌ 不能（得用闭包） | ✅ 可以 |
| 类型 | 模糊（Function） | 清晰（类名） |
| 可扩展 | ❌ | ✅ 可继承、可加方法 |

---

## 第37课：import 导入

```dart
import 'math.dart';               // 自己写的文件
import 'dart:math';               // Dart 标准库
import 'package:http/http.dart';  // 第三方包（Flutter 项目）
```

`dart:core` 自动导入，不需要写。里面包含 `print`、`String`、`int`、`Future`、`List`、`Map` 等。

---

## 第38课：copyWith 不可变更新

```dart
class User {
  final String name, email;
  final int age;
  const User(this.name, this.age, this.email);

  User copyWith({String? name, int? age, String? email}) {
    return User(
      name ?? this.name,  // 没传就用原来的
      age ?? this.age,
      email ?? this.email,
    );
  }
}

var u1 = User('小明', 25, '...');
var u2 = u1.copyWith(age: 26);  // 只改年龄，其他不变
```

**原理：** `??` 左边如果为 null（没传参），就用右边的原值。所有字段用 `final`，不可变。

---

## 第39课：Isolate 并发

```dart
import 'dart:isolate';

void main() async {
  // 同时启动多个 Isolate，各跑各的
  var r1 = Isolate.run(() => fibonacci(35));
  var r2 = Isolate.run(() => fibonacci(40));

  // 先算完的先出结果
  r1.then((v) => print('线程1: $v'));
  r2.then((v) => print('线程2: $v'));
}
```

**对比：Future vs Isolate**

| | Future / async-await | Isolate |
|---|---|---|
| 线程 | 同一线程 | **新线程** |
| 利用多核 CPU？ | ❌ 不能 | ✅ 能 |
| 适合场景 | 等网络、等文件 | 大量计算、JSON 解析 |

**类比：** async-await 是等外卖（CPU 空闲），Isolate 是真让另一个 CPU 干活。

---

## 第40课：extension type 扩展类型

```dart
extension type UserId(int value) {  // 包装 int
  bool get isValid => value > 0;
}

void deleteUser(UserId id) { ... }

deleteUser(UserId(5));  // ✅
deleteUser(5);          // ❌ 编译报错！int 不能当 UserId 用
```

**对比：extension type vs class vs extension**

| | class | extension type | extension |
|---|---|---|---|
| 运行时开销 | 有 | **零开销** | 零开销 |
| 能加方法/属性 | ✅ | ✅（getter 只读） | ✅（无字段） |
| 隐藏原始类型 | ❌ | ✅ 外部看不到原始值 | ❌ |
| 适合场景 | 复杂业务对象 | 轻量包装，避免传错类型 | 给已有类型加方法 |

---

## 第47课：JSON 编解码 (dart:convert)

```dart
import 'dart:convert';

// JSON → Dart
var map = jsonDecode('{"name":"小明","age":25}') as Map<String, dynamic>;
print(map['name']);  // 小明

// Dart → JSON
var json = jsonEncode({'name': '小红', 'age': 22});
```

**自定义类序列化：**
```dart
class Person {
  String name; int age;

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['name'], json['age']);
  }
}

var p = Person('小明', 25);
jsonEncode(p.toJson());              // 对象 → JSON
Person.fromJson(jsonDecode(jsonStr)); // JSON → 对象
```

**格式化输出：**
```dart
const JsonEncoder.withIndent('  ').convert(data);
```

**注意：**
- jsonDecode 返回 `dynamic`，需用 `as` 转换
- 嵌套对象要在 `toJson`/`fromJson` 里递归处理
- 缺失字段用 `??` 给默认值
- 自定义类如果没有 `toJson`，可以给 `jsonEncode` 传 `toEncodable` 回调

---

## 第49课：正则表达式 (RegExp)

```dart
void main() {
  // 创建正则：匹配手机号（11位数字）
  var phoneReg = RegExp(r'^1[3-9]\d{9}$');

  print(phoneReg.hasMatch('13812345678')); // true
  print(phoneReg.hasMatch('12345'));       // false
}
```

**用法：**

```dart
// 创建正则
RegExp(r'模式');           // r 表示原始字符串，反斜杠不会转义
RegExp('模式');            // 不写 r，\d 要写成 \\d（麻烦）

// 常用方法
reg.hasMatch('字符串');         // 是否匹配 → bool
reg.firstMatch('字符串');       // 第一个匹配结果
reg.allMatches('字符串');       // 所有匹配结果 → Iterable<RegExpMatch>
reg.stringMatch('字符串');      // 返回匹配到的子串

// 替换
'abc123def'.replaceAll(RegExp(r'\d+'), 'X');  // abcXdef
```

**常用正则模式：**

| 模式 | 含义 | 例子 |
|------|------|------|
| `\d` | 数字 | `r'\d+'` → 匹配连续数字 |
| `\w` | 字母/数字/下划线 | `r'\w+'` → 匹配单词 |
| `\s` | 空白字符（空格/换行/tab） | `r'\s+'` → 匹配空白 |
| `.` | 任意字符（除换行） | `r'.+'` → 匹配任何内容 |
| `*` | 前一个出现 0 次或多次 | `r'\d*'` |
| `+` | 前一个出现 1 次或多次 | `r'\d+'` |
| `?` | 前一个出现 0 次或 1 次 | `r'\d?'` |
| `{n}` | 恰好 n 次 | `r'\d{11}'` → 11位数字 |
| `{n,}` | 至少 n 次 | `r'\d{3,}'` |
| `{n,m}` | n 到 m 次 | `r'\d{3,5}'` |
| `^` | 开头 | `r'^hello'` |
| `$` | 结尾 | `r'world$'` |
| `[abc]` | 字符集合 | `r'[aeiou]'` → 匹配任意元音 |
| `[a-z]` | 字符范围 | `r'[0-9]'` = `\d` |
| `[^abc]` | 排除 | `r'[^0-9]'` → 匹配非数字 |
| `()` | 分组捕获 | `r'(\d{4})-(\d{2})'` |

**对比：RegExp vs 字符串方法**

| 场景 | 字符串方法 | RegExp |
|------|-----------|--------|
| 是否包含某子串 | `s.contains('abc')` | `reg.hasMatch(s)` |
| 替换固定字符 | `s.replaceAll('a', 'b')` | `s.replaceAll(RegExp(r'a'), 'b')` |
| 验证格式（邮箱/手机） | ❌ 做不到 | ✅ `r'^1[3-9]\d{9}$'` |
| 提取复杂模式 | `s.substring` 太麻烦 | ✅ `reg.allMatches` |

**注意：**
- 创建正则时**务必写 `r`** 前缀，不然 `\d` 要写成 `\\d`，很痛苦
- `hasMatch` 只检查是否匹配，`allMatches` 能拿到匹配位置和分组
- 分组用 `match.group(1)` 取值，`match.group(0)` 是整个匹配

---

## 第48课：文件读写 (dart:io)

```dart
import 'dart:io';

void main() async {
  // 写入文件
  var file = File('test.txt');
  await file.writeAsString('Hello, Dart!');

  // 读取文件
  var content = await file.readAsString();
  print(content); // Hello, Dart!
}
```

**用法：**

```dart
// 创建/写入（覆盖）
await File('路径').writeAsString('内容');

// 追加写入
await File('路径').writeAsString('追加内容', mode: FileMode.append);

// 读取全部内容
String content = await File('路径').readAsString();

// 按行读取
List<String> lines = await File('路径').readAsLines();

// 读取二进制
List<int> bytes = await File('路径').readAsBytes();

// 判断文件是否存在
bool exists = await File('路径').exists();

// 删除文件
await File('路径').delete();

// 复制文件
await File('源路径').copy('目标路径');
```

**对比：同步 vs 异步文件操作**

| | 同步方法 | 异步方法 |
|---|---|---|
| 读字符串 | `readAsStringSync()` | `readAsString()` |
| 写字符串 | `writeAsStringSync()` | `writeAsString()` |
| 按行读 | `readAsLinesSync()` | `readAsLines()` |
| 适合场景 | 小文件、命令行脚本 | 大文件、不阻塞 UI |

**注意：**
- `dart:io` 只能在**非 Web** 平台使用（CLI、服务器、Flutter）
- 路径可以是相对路径或绝对路径
- 文件不存在时读文件会抛 `FileSystemException`
- 用 `try-catch` 包裹文件操作，防止崩溃

---

## 第50课：排序与 Comparable

```dart
void main() {
  var nums = [3, 1, 4, 1, 5];
  nums.sort();                    // 默认升序 [1, 1, 3, 4, 5]

  var names = ['小明', '小红', '小刚'];
  names.sort((a, b) => b.compareTo(a));  // 降序
}
```

**Comparable 接口：**
```dart
class Student implements Comparable<Student> {
  String name;
  int score;
  @override
  int compareTo(Student other) => score.compareTo(other.score);
}

var students = [Student('小明', 85), Student('小红', 92)];
students.sort();  // 按分数排序
```

**对比：`sort()` 的两种用法**

| | 类实现 Comparable | 传入 Comparator |
|---|---|---|
| 写法 | `list.sort()` | `list.sort((a, b) => ...)` |
| 排序规则 | 固定写死在类里 | 临时决定 |
| 多种排序 | ❌ 只有一种 | ✅ 随时换规则 |

**Comparator 返回值规则：**
- `a.compareTo(b) < 0` → a 排在 b 前面（升序）
- `a.compareTo(b) > 0` → a 排在 b 后面（降序）
- `a.compareTo(b) == 0` → 相等

---

## 第51课：Timer 定时器

```dart
import 'dart:async';

void main() {
  // 2秒后执行一次
  Timer(Duration(seconds: 2), () {
    print('2秒到了');
  });

  // 每秒执行一次，执行5次后取消
  int count = 0;
  Timer.periodic(Duration(seconds: 1), (timer) {
    count++;
    print('第$count秒');
    if (count >= 5) timer.cancel();
  });
}
```

**用法：**

```dart
// 延迟执行一次
Timer(Duration(seconds: 3), () => print('3秒后'));

// 定时重复执行
Timer.periodic(Duration(seconds: 1), (timer) {
  print('每秒一次');
});

// 取消定时器
var timer = Timer(Duration(seconds: 10), () => print('不会执行'));
timer.cancel();  // 取消后回调不会触发

// 判断是否还在运行
timer.isActive  // true = 还没执行/还没取消
```

**对比：Timer vs Future.delayed**

| | Timer | Future.delayed |
|---|---|---|
| 延迟执行 | ✅ `Timer(3s, fn)` | ✅ `Future.delayed(3s, fn)` |
| 重复执行 | ✅ `Timer.periodic` | ❌ 不能 |
| 取消 | ✅ `timer.cancel()` | ❌ 不能取消 |
| 使用场景 | 定时任务、倒计时 | 延迟一次且不需要取消 |

**注意：**
- `dart:async` 自动导入，不需要写 `import`
- 定时器回调结束后 Timer 对象会被回收
- `Timer.periodic` 记得在条件满足时 `cancel()`，否则一直运行
- 取消后的 Timer 再调 `cancel()` 不会报错（幂等）

---

## 第52课：StreamController 流控制

```dart
import 'dart:async';

void main() {
  // 创建控制器
  var controller = StreamController<int>();

  // 监听流
  controller.stream.listen((data) {
    print('收到: $data');
  });

  // 往流里添加数据
  controller.add(1);
  controller.add(2);
  controller.add(3);

  // 关闭流
  controller.close();
}
```

**用法：**

```dart
var c = StreamController<int>();

c.stream.listen(回调);         // 监听数据
c.add(值);                     // 添加单个数据
c.addStream(另一个Stream);      // 添加整个流
c.done                         // Future，流关闭后触发
c.close();                     // 关闭，不再接收新数据
```

**对比：async* vs StreamController**

| | async* / yield | StreamController |
|---|---|---|
| 数据源控制 | 内部固定（函数内 yield） | **外部手动** add |
| 适用场景 | 数据由函数内部产生 | 数据来自外部事件（按钮点击、WebSocket） |
| 灵活性 | 低，数据产生逻辑固定 | 高，任何地方都能 add |
| 代码量 | 少 | 多 |

**注意：**
- 一个 `StreamController` 只能被**监听一次**（默认情况）
- 用完后必须 `close()`，否则会内存泄漏
- 可以设置 `onCancel` 回调，在监听者取消时清理资源
- `StreamController.broadcast()` 创建广播流，允许多次监听

---

## 第53课：增强枚举（带字段和方法）

```dart
enum StatusCode {
  success(200, '成功'),
  notFound(404, '未找到'),
  error(500, '服务器错误');

  final int code;
  final String message;
  const StatusCode(this.code, this.message);

  bool get isOk => code < 400;
  String format() => '[$code] $message';
}

void main() {
  var s = StatusCode.success;
  print(s.code);     // 200
  print(s.message);  // 成功
  print(s.isOk);     // true
  print(s.format()); // [200] 成功
}
```

**用法：**

```dart
enum Color {
  red(0xFF0000),
  green(0x00FF00),
  blue(0x0000FF);

  final int hex;
  const Color(this.hex);

  String get hexStr => '#${hex.toRadixString(16).padLeft(6, '0')}';
}

print(Color.red.hexStr);  // #ff0000
```

**对比：普通枚举 vs 增强枚举**

| | 普通枚举 | 增强枚举 |
|---|---|---|
| 字段 | ❌ 不能 | ✅ 可以有 |
| 方法 | ❌ 不能 | ✅ 可以有 |
| getter/setter | ❌ 不能 | ✅ 可以有 |
| 实现接口 | ❌ 不能 | ✅ 可以 `implements` |
| 适用场景 | 简单的常量列表 | 需要附带数据或行为的枚举 |

**注意：**
- 构造函数必须是 `const`
- 所有枚举值在类体最后列出，用 `;` 结尾
- 值之间用 `,` 分隔，最后一个用 `;`
- 可以加 getter、方法、甚至实现接口

---

## 第54课：sync* 同步生成器

```dart
void main() {
  // sync* 返回 Iterable，数据随取随生成
  for (var n in countTo(5)) {
    print(n);  // 1 2 3 4 5
  }
}

// sync* 生成器：每次 yield 一个值，惰性求值
Iterable<int> countTo(int n) sync* {
  for (int i = 1; i <= n; i++) {
    yield i;
  }
}
```

**对比：sync* vs async\***

| | sync* | async\* |
|---|---|---|
| 返回类型 | `Iterable<T>` | `Stream<T>` |
| 求值方式 | **惰性**（用到才生成） | **惰性**（有人监听才生成） |
| 等待 | 同步，不 await | 异步，可 await |
| yield 语法 | 相同 | 相同 |
| 适用场景 | 大量数据的惰性计算 | 异步事件流 |

**惰性求值：**

```dart
Iterable<int> numbers() sync* {
  print('生成1');
  yield 1;
  print('生成2');
  yield 2;
  print('生成3');
  yield 3;
}

var it = numbers().iterator;
it.moveNext(); print(it.current);  // 打印"生成1"和"1"
it.moveNext(); print(it.current);  // 打印"生成2"和"2"
// 每次只生成一个，用多少算多少
```

**注意：**
- sync* 函数用 `Iterable` 作为返回类型
- 用 `yield` 返回值，可以多次
- 也可以用 `yield*` 委托给另一个 Iterable
- 适合生成大量数据（斐波那契、分页遍历），避免一次性加载到内存

---

## 第55课：Process 进程（执行系统命令）

```dart
import 'dart:io';

void main() async {
  // 执行命令并获取输出
  var result = await Process.run('dart', ['--version']);
  print(result.stdout);  // Dart SDK version...

  // 实时输出
  var process = await Process.start('ping', ['127.0.0.1', '-n', '3']);
  await for (var line in process.stdout.transform(utf8.decoder)) {
    print(line);
  }
}
```

**用法：**

```dart
// 方式一：一次性获取结果（简单）
var r = await Process.run('命令', ['参数1', '参数2']);
r.stdout      // 标准输出（String）
r.stderr      // 错误输出（String）
r.exitCode    // 退出码（0=成功）

// 方式二：实时流式输出（适合长时间运行的命令）
var p = await Process.start('命令', ['参数']);
p.stdout        // Stream<List<int>>，需要解码
p.stderr        // 错误输出流
p.stdin         // 向进程输入
p.kill();       // 终止进程
await p.exitCode;  // 等待进程结束
```

**对比：Process.run vs Process.start**

| | Process.run | Process.start |
|---|---|---|
| 返回 | 一次性拿到全部输出 | 流式输出 |
| 适合 | 快速命令、结果短 | 长时间运行、需要实时看输出 |
| 使用场景 | `git status`、`dart --version` | `ping`、`build`、`serve` |

**注意：**
- `stdout` 是二进制流 `Stream<List<int>>`，需要用 `utf8.decoder` 转字符串
- `run` 默认把 stdout/stderr 合并成字符串，适合短输出
- `exitCode` 为 0 表示成功，非 0 表示出错
- 用 `kill()` 强制终止进程，用 `exitCode` 等待自然结束

---

## 第56课：Uri 类（URL 解析与构建）

```dart
void main() {
  // 解析 URL
  var uri = Uri.parse('https://example.com/path?a=1&b=2#section');
  print(uri.scheme);     // https
  print(uri.host);       // example.com
  print(uri.path);       // /path
  print(uri.query);      // a=1&b=2
  print(uri.fragment);   // section

  // 构建 URL
  var url = Uri(
    scheme: 'https',
    host: 'api.example.com',
    path: '/users',
    queryParameters: {'page': '1', 'size': '20'},
  );
  print(url);  // https://api.example.com/users?page=1&size=20
}
```

**用法：**

```dart
// 解析
Uri.parse('https://user:pass@host:8080/path?q=1#top')
uri.scheme        // https
uri.host          // host
uri.port          // 8080
uri.userInfo      // user:pass
uri.path          // /path
uri.query         // q=1
uri.queryParameters  // {'q': '1'}
uri.fragment      // top

// 构建
Uri(
  scheme: 'https',
  host: 'example.com',
  path: '/search',
  queryParameters: {'q': 'dart', 'page': '1'},
)

// 编码/解码
Uri.encodeComponent('你好')   // %E4%BD%A0%E5%A5%BD
Uri.decodeComponent('%E4%BD%A0%E5%A5%BD')  // 你好

// 相对路径
Uri.base.resolve('../other/file.txt')
```

**对比：Uri.parse vs Uri 构造函数**

| | Uri.parse | Uri() 构造函数 |
|---|---|---|
| 用途 | 从字符串解析 | 用参数构建 |
| 参数 | 一个 URL 字符串 | 分别传 scheme/host/path... |
| 适用 | 处理已有 URL | 动态构造 URL |

**注意：**
- `Uri` 是 `dart:core` 里的类，**不需要 import**
- `.queryParameters` 返回 `Map<String, String>`，重复的 key 会合并
- 中文等特殊字符用 `Uri.encodeComponent()` 编码
- `Uri.base` 获取当前脚本所在目录

---

## 第57课：自定义异常

```dart
class ValidationException implements Exception {
  final String message;
  final String field;
  ValidationException(this.message, this.field);

  @override
  String toString() => '[$field] $message';
}

void main() {
  try {
    validateAge(-5);
  } on ValidationException catch (e) {
    print(e);  // [age] 年龄不能为负数
  }
}

void validateAge(int age) {
  if (age < 0) throw ValidationException('年龄不能为负数', 'age');
}
```

**用法：**

```dart
// 定义
class MyException implements Exception {
  final String message;
  MyException(this.message);
  @override
  String toString() => message;
}

// 抛出
throw MyException('出错了');

// 捕获
try {
  doSomething();
} on MyException catch (e) {
  print(e.message);
}
```

**对比：Exception vs Error**

| | Exception | Error |
|---|---|---|
| 含义 | 可处理的异常 | 程序 bug，不该捕获 |
| 例子 | 网络超时、参数校验失败 | 空指针、越界 |
| 父类 | `Exception` | `Error` |
| 是否捕获 | ✅ 应该用 try-catch 处理 | ❌ 应该修代码 |

**注意：**
- 自定义异常类用 `implements Exception`（不是 `extends`）
- 重写 `toString()` 让错误信息更清晰
- 可以用多个 `on` 分支捕获不同类型的异常
- `rethrow` 把异常往上抛，由外层处理

---

## 第58课：Isolate 通信（SendPort / ReceivePort）

```dart
import 'dart:isolate';

void main() async {
  // 创建一个 ReceivePort 来接收消息
  var receiver = ReceivePort();

  // 启动 Isolate，把 receiver.sendPort 传过去
  await Isolate.spawn(worker, receiver.sendPort);

  // 接收 Isolate 发来的消息
  var msg = await receiver.first;
  print('收到: $msg');
}

void worker(SendPort sendPort) {
  sendPort.send('你好，从 Isolate 发来的消息');
}
```

**通信方式：**

```dart
// 主 Isolate
var receiver = ReceivePort();
await Isolate.spawn(worker, receiver.sendPort);
var msg = await receiver.first;    // 等一条消息

// 工作 Isolate
void worker(SendPort sendPort) {
  sendPort.send('消息');           // 发回主 Isolate
}
```

**对比：isolate.run vs 手动通信**

| | `Isolate.run` | 手动 SendPort/ReceivePort |
|---|---|---|
| 返回结果 | 一次性返回值 | **多次**收发消息 |
| 双向通信 | ❌ 不能 | ✅ 可以来回通信 |
| 适用场景 | 一次计算出结果 | 持续交互、流式数据 |

**注意：**
- `SendPort` 只能发消息，`ReceivePort` 只能收消息
- 传过去的参数必须是**可跨 Isolate 的**（基本类型、List、Map、SendPort）
- 建立双向通信：工作 Isolate 也要有自己的 `ReceivePort`，把它的 `sendPort` 传回主 Isolate
- Isolate 之间不共享内存，只能通过消息传递

---

## 第59课：StringBuffer 高效字符串拼接

```dart
void main() {
  // StringBuffer：累积字符串，最后一次性取结果

  var sb = StringBuffer();
  sb.write('Hello');
  sb.write(' ');
  sb.write('Dart');
  sb.writeAll(['!', ' ', '你好']);

  print(sb.toString());  // Hello Dart! 你好
}
```

**用法：**

```dart
var sb = StringBuffer();

sb.write('内容');           // 追加字符串
sb.writeln('行');           // 追加并换行
sb.writeAll(['a', 'b']);    // 追加列表所有元素
sb.writeAll(['a', 'b'], ', '); // 用分隔符连接
sb.clear();                 // 清空

sb.isEmpty;                 // 是否为空
sb.isNotEmpty;              // 是否不为空
sb.length;                  // 当前字符数

sb.toString();              // 取出最终字符串
```

**对比：字符串拼接 vs StringBuffer**

| | `+` 拼接 | `StringBuffer` |
|---|---|---|
| 性能 | 慢（每次创建新字符串） | **快**（内部缓冲区） |
| 适合 | 少量（3-5个）拼接 | **大量**（循环拼接） |
| 代码 | `str1 + str2 + str3` | `sb.write(a)..write(b)..write(c)` |

**为什么 StringBuffer 快？**

```dart
// 用 +：每次创建新字符串，复制全部内容
var s = '';
for (int i = 0; i < 10000; i++) {
  s += '第$i行\n';  // 复制越来越长的字符串 → 慢
}

// 用 StringBuffer：累积到缓冲区，最后一次性创建
var sb = StringBuffer();
for (int i = 0; i < 10000; i++) {
  sb.writeln('第$i行');  // 只写到缓冲区 → 快
}
var s = sb.toString();  // 最后才创建字符串
```

---

## 第60课：dart:collection 集合类型深入

```dart
import 'dart:collection';

void main() {
  // Queue — 先进先出（排队）
  var queue = Queue<String>();
  queue.addLast('甲');  // 排队
  queue.addLast('乙');
  queue.addLast('丙');
  print(queue.removeFirst());  // 甲（先排的先处理）

  // HashMap / LinkedHashMap / SplayTreeMap
  var hash   = HashMap<int, String>();   // 无序（最快）
  var linked = LinkedHashMap<int, String>(); // 按插入顺序
  var tree   = SplayTreeMap<int, String>();  // 按键排序

  // HashSet / LinkedHashSet / SplayTreeSet
  var hSet = HashSet<int>();       // 无序
  var lSet = LinkedHashSet<int>(); // 按插入顺序
  var tSet = SplayTreeSet<int>();  // 排序

  // 不可变包装
  var list = [1, 2, 3];
  var unmodifiable = UnmodifiableListView(list);
  // unmodifiable[0] = 99;  // ❌ 运行时报错
}
```

**对比：Map 的三种实现**

| | HashMap | LinkedHashMap | SplayTreeMap |
|---|---|---|---|
| 顺序 | 无序 | **插入顺序** | **键排序** |
| 性能 | 最快 | 和 HashMap 接近 | 略慢 |
| 默认 Map 是？ | ❌ | ✅ `Map()` 就是它 |

**对比：Set 的三种实现**

| | HashSet | LinkedHashSet | SplayTreeSet |
|---|---|---|---|
| 顺序 | 无序 | **插入顺序** | **排序** |
| 默认 Set 是？ | ❌ | ✅ `Set()` 就是它 |

**Queue 核心操作：**

```dart
queue.addFirst(e)   // 队首添加
queue.addLast(e)    // 队尾添加（默认）
queue.removeFirst() // 取队首
queue.removeLast()  // 取队尾
queue.first         // 看队首不移除
queue.last          // 看队尾不移除
```

**注意：**
- `Queue` 适合"先进先出"的场景（排队、任务调度）
- `UnmodifiableListView` 只是运行时保护，编译时不会报错
- `SplayTreeMap` 的键必须实现 `Comparable`（或传比较函数）

---

## 第61课：NoSuchMethod（拦截不存在的方法）

```dart
class Proxy {
  @override
  void noSuchMethod(Invocation invocation) {
    print('调用了不存在的方法: ${invocation.memberName}');
    print('参数: ${invocation.positionalArguments}');
  }
}

void main() {
  // 把 Proxy 当成任意类型用
  dynamic proxy = Proxy();
  proxy.sayHello('小明');  // 不会崩溃，进 noSuchMethod
  proxy.add(1, 2);
}
```

**用法：**

```dart
class MyProxy {
  @override
  void noSuchMethod(Invocation inv) {
    if (inv.memberName == #sayHello) {
      print('你好, ${inv.positionalArguments[0]}');
    } else {
      super.noSuchMethod(inv);  // 不处理的交给默认逻辑
    }
  }
}
```

**Invocation 的属性和方法：**

```dart
inv.memberName           // 方法名（Symbol）
inv.positionalArguments  // 位置参数列表
inv.namedArguments       // 命名参数 Map
inv.isMethod             // 是否是方法调用
inv.isGetter             // 是否是 getter
inv.isSetter             // 是否是 setter
inv.typeArguments        // 泛型类型参数
```

**注意：**
- 类必须声明 `dynamic` 类型才能触发 `noSuchMethod`
- 需要加 `@override` 覆盖
- 不处理的方法调 `super.noSuchMethod(inv)` 抛默认异常
- 适合做代理、Mock、动态接口

---

## 第62课：模式匹配进阶（guards、null-check、switch 模式）

```dart
void main() {
  // Guard（when）：匹配时加额外条件
  (int a, int b) pair = (2, 3);
  switch (pair) {
    case (int x, int y) when x == y:
      print('相等');
    case (int x, int y) when x > y:
      print('x 大');
    case (int x, int y):
      print('y 大');
  }

  // Null-check / null-assert 模式
  String? name = '小明';
  if (name case var n?) {
    print('有值: $n');  // 只有非 null 才匹配
  }

  // List 解构
  var list = [1, 2, 3, 4, 5];
  var [a, b, ...rest] = list;
  print('$a, $b, $rest');  // 1, 2, [3, 4, 5]

  // Map 解构
  var map = {'name': '小明', 'age': 25};
  var {'name': name2, 'age': age2} = map;
  print('$name2, $age2');
}
```

**用法：**

```dart
// Guard — when 关键字
case (int x, int y) when x + y > 10:
case (int x) when x.isEven:

// Null-check — 变量名?
String? s = 'hello';
if (s case var v?) { print('非空: $v'); }

// 剩余元素 — ...
var [first, ...rest] = [1, 2, 3, 4];
var [...all, last] = [1, 2, 3];  // rest + last

// 嵌套解构
var json = {'user': {'name': '小明', 'age': 25}};
var {'user': {'name': n, 'age': a}} = json;
```

**对比：**

| 模式 | 用途 | 例子 |
|------|------|------|
| `when` | 匹配后加条件 | `case (x, y) when x > y:` |
| `var n?` | 非 null 才匹配 | `if (s case var v?)` |
| `...` | 剩余元素 | `var [a, ...rest] = list` |
| 嵌套解构 | 深层提取 | `{'a': {'b': x}}` |

---

## 第63课：注解（Annotations / 元数据）

```dart
// 定义注解
class Deprecated {
  final String message;
  const Deprecated(this.message);
}

// 使用注解
@Deprecated('请使用新方法')
void oldMethod() { }

void main() {
  // 读取注解
  var obj = oldMethod;
  var metadata = obj.metadata;
  for (var m in metadata) {
    if (m is Deprecated) {
      print(m.message);  // 请使用新方法
    }
  }
}
```

**定义注解：**

```dart
// 注解就是普通的类，构造函数必须是 const
class Required { const Required(); }
class Range { final int min, max; const Range(this.min, this.max); }
class Length { final int min, max; const Length({this.min = 0, this.max = 100}); }
```

**使用注解：**

```dart
@Required()
@Range(min: 1, max: 100)
@Length(min: 2, max: 10)
String name = '';
```

**读取注解（反射）：**

```dart
import 'dart:mirrors';  // 需要反射库

// 或通过 Type 对象
var type = SomeClass;
for (var m in type.metadata) {
  if (m is MyAnnotation) { ... }
}
```

**对比：注解 vs 普通类**

| | 注解 | 普通类 |
|---|---|---|
| 构造函数 | **必须 const** | 可以不 const |
| 放在哪 | 类/方法/字段前面加 `@` | new 对象 |
| 作用 | 附加元数据 | 实例化使用 |
| 读取 | 通过反射或代码生成 | 直接调用 |

**注意：**
- 注解类构造函数必须 `const`
- `dart:mirrors` 在 Flutter 和 Web 上不可用
- 广泛用于代码生成（json_serializable、freezed）
- Dart 内置注解：`@override`、`@deprecated`、`@pragma`

---

## 第64课：异步进阶 — Future 组合与超时处理

```dart
Future.wait([fetchUser(), fetchOrders()]);   // 等所有完成
Future.any([sourceA(), sourceB()]);           // 谁先完成用谁
future.timeout(Duration(seconds: 2));         // 超时处理
Future.delayed(Duration(seconds: 1), fn);     // 延迟执行
Future.value('data');                          // 直接创建成功 Future
Future.error(Exception('错'));                 // 直接创建失败 Future
Future.sync(() => '同步结果');                 // 同步执行包装为 Future
Future.forEach([1, 2, 3], (i) async {});       // 顺序异步遍历
```

**对比：顺序 vs 并发**

```dart
// 顺序执行 — 总耗时 = 累加
var a = await taskA();  // 800ms
var b = await taskB();  // + 500ms = 1300ms

// 并发执行 — 总耗时 = 最慢的
var [a, b] = await Future.wait([taskA(), taskB()]);  // max(800, 500) = 800ms
```

**实际模式：**

```dart
// 失败重试
for (int i = 0; i < 3; i++) {
  try { result = await api(); break; }
  catch (e) { if (i < 2) await Future.delayed(退避时间); }
}

// 并发限流（分批）
var batches = chunked(tasks, 2);  // 每批 2 个
for (var batch in batches) {
  await Future.wait(batch.map((t) => t()));
}

// 超时 + 重试组合
for (int i = 0; i < 3; i++) {
  try {
    result = await api().timeout(1.seconds, onTimeout: () => throw ...);
    break;
  } catch (e) { /* 重试 */ }
}
```

**注意：**
- `Future.wait` 是**并发**，不是顺序，多个 Future 同时跑
- 超时时间要根据业务设置，太短容易误判
- 重试要加退避（backoff），避免打爆服务器
- 并发数要合理（一般 3-5 个），太多会耗尽资源

---

## 第46课：DateTime 日期时间处理

```dart
var now = DateTime.now();                                    // 当前时间
var date = DateTime(2026, 6, 2);                             // 指定日期
var parsed = DateTime.parse('2026-06-02');                   // 解析字符串
var fromTs = DateTime.fromMillisecondsSinceEpoch(ts);        // 时间戳→日期
```

**读取各部分：**
```dart
dt.year  dt.month  dt.day  dt.hour  dt.minute  dt.second
dt.weekday  // 1=周一, 7=周日
```

**计算：**
```dart
dt.add(Duration(days: 7));              // 加7天
dt.subtract(Duration(days: 3));         // 减3天
b.difference(a).inDays;                 // 相差天数
DateTime(dt.year, dt.month + 1, dt.day); // 加1个月（注意进位）
```

**比较：**
```dart
a.isBefore(b)  a.isAfter(b)  a.isAtSameMomentAs(b)
```

**注意陷阱：**
- `Duration` 没有 `months` 参数，加减月份需用构造函数
- `==` 比较时刻而非日期，判断同一天要比较 `year+month+day`
- `.parse()` 只认 ISO 8601 格式，其他格式需手动替换转换

---

# 常见疑问解答

## 类型相关

**Q: double 是什么类型？**
A: 浮点数，存带小数的数字。与 `int`（整数）相对。`10 / 3` 返回 `double`，`10 ~/ 3` 返回 `int`。

**Q: void 做什么用？**
A: 表示方法没有返回值。`void sayHello() {}` 执行完不返回任何东西。

**Q: sqrt 是什么？**
A: `dart:math` 库里的平方根函数：`sqrt(16)` → `4.0`。

## 参数相关

**Q: Map.forEach 遍历时参数顺序？**
A: 第一个是**键**（key），第二个是**值**（value）：`scores.forEach((键, 值) { })`。

**Q: 可选位置参数和命名参数的区别？**
A: 命名参数用 `{}`，调用时写参数名；可选位置参数用 `[]`，按顺序传值。两者都可以有默认值。

## 面向对象相关

**Q: 抽象类和实体类什么区别？**
A: 抽象类（`abstract`）不能 `new`，可以有抽象方法。实体类可以 `new`，不能有抽象方法。

**Q: 抽象方法是什么？**
A: 只有声明没有方法体：`double area();`。子类必须实现它。

**Q: @override 做什么？**
A: 标记方法是对父类的重写。不加也能重写，但加了如果父类没这个方法，编译器会报错。

**Q: implements 什么意思？**
A: "实现"——类必须按规范重写所有方法，不能偷懒。

**Q: extends vs implements vs with 区别？**
A: `extends` 继承代码（父子关系，只能一个）；`implements` 签合同（可多个，全得自己写）；`with` 混入能力（可多个，代码直接拿来用）。

**Q: super 在继承中必须写吗？**
A: 父类有默认构造函数可以不写，否则必须用 `super(...)` 传参。

**Q: Mixin 什么时候用？**
A: 多个类有**同一种能力**但不是父子关系时。比如鱼和狗都会游，用 `mixin Swimmer`。

**Q: _internal 什么意思？**
A: Dart 里 `_` 开头表示私有，只能在本文件访问。`Config._internal()` 是私有构造函数，强迫外部通过 `factory` 创建。

**Q: factory 构造函数什么场景用？**
A: 单例、缓存、对象池——需要控制对象创建逻辑时。

**Q: this 在构造函数中的作用？**
A: `this.name` 指对象的属性，区分参数名。`Animal(this.name, this.age)` 是简写。

**Q: getter/setter 怎么工作？**
A: getter 像属性一样读（`rect.area`），setter 像属性一样写（`rect.area = 30`），背后可以执行计算逻辑。

**Q: static 成员和普通成员区别？**
A: static 属于类（`类名.调用`），普通成员属于对象（`对象.调用`）。

**Q: callable class 和普通函数区别？**
A: callable class 可以"记住"状态、有类型名、可扩展。普通函数适合简单场景。

## 泛型相关

**Q: K 和 V 在泛型中什么意思？**
A: K = Key（键的类型），V = Value（值的类型）。`Pair<K, V>` 表示一个键值对容器。

**Q: 泛型和 dynamic 区别？**
A: 泛型编译时检查类型安全，`dynamic` 运行时才检查。泛型用错编译报错，`dynamic` 可能运行时报错。

## 枚举相关

**Q: 枚举为什么不能用中文？**
A: 枚举值必须是合法的标识符（字母、数字、下划线），中文不是合法标识符。

**Q: 枚举做什么用？**
A: 表示一组固定选项，编译器会检查拼写。`switch` 配合枚举可以全覆盖检查。

## 数据结构相关

**Q: Map 和 Object 区别？**
A: Map 是键值对数据结构。Object 是所有类型的根类。Map 是 Object 的一种，但 Object 不一定是 Map。

**Q: Map 和类对象区别？**
A: Map 动态灵活但无类型检查，类对象有类型检查、有行为方法、性能更好。

**Q: Record 和类有什么区别？**
A: Record 不用定义直接用，适合临时组合几个值。类需要定义，适合有行为、需复用的实体。

**Q: collection 方法（where/map 等）返回为什么是圆括号？**
A: 返回的是 `Iterable` 不是 `List`，打印用 `()`。`.toList()` 转成 `[]`。

## 变量与常量相关

**Q: final vs const vs var 区别？**
A: `var` 可修改；`final` 运行时赋值一次；`const` 编译时确定。`const DateTime.now()` 报错，因为编译时不可知。

**Q: late 延迟在哪？**
A: 延迟的是初始化时机——`late` 变量在第一次访问时才初始化，不是创建对象时。

## 属性与访问器相关

**Q: containsKey 什么意思？**
A: Map 的方法，检查某个键是否存在。`map.containsKey('key')`。

**Q: hashCode 为什么要和 == 一起重写？**
A: 重写 `==` 后，如果 hashCode 不一致，Set/Map 去重会判断两个相等的对象为不等，导致逻辑错误。

## 调试相关

**Q: assert 为什么默认不生效？**
A: `dart run` 默认不启用 assert，需加 `--enable-asserts` 标志。生产环境自动跳过，零开销。

**Q: assert 的使用场景？**
A: 检查"理论上不应该发生"的错误。用户输入、网络请求等不可控场景用 if-throw。

## 模式匹配相关

**Q: Map 解构为什么不能像 Record 一样简写？**
A: Map 的键是运行时字符串，Record 的字段名是编译时标识符，本质不同。

**Q: sealed class 比抽象类好在哪里？**
A: switch 全覆盖检查——漏掉一个子类编译报错。适合状态管理。

## 运算符相关

**Q: == 重写了为什么 p1 == p2 为 false？**
A: 因为重写后的 `==` 比较的是坐标值（x, y），`p1` 是 (1,2)，`p2` 是 (3,4)，不相等。如果 `p2 = Point(1, 2)` 则相等。

## 函数相关

**Q: 为什么方法一定要写返回类型？**
A: Dart 要求所有顶层函数和方法声明返回类型或 `void`。不写会默认为 `dynamic`，失去类型检查。

**Q: typedef 用来做什么？**
A: 给复杂类型起别名。比如 `bool Function(int age)` 可以变成 `Filter`。

## 并发相关

**Q: Isolate 和 JS async 的区别？**
A: JS async 是单线程"排队"，Isolate 是真多线程"新开一个 CPU 核"。

## 数学相关

**Q: dart:math 里有哪些常用函数？**
A: `pi`、`sqrt`（平方根）、`max`/`min`（最大/最小值）、`pow`（幂）、`Random`（随机数）。

## 类型对比

**Q: extension type vs class vs extension 区别？**
A: extension type 零开销编译时包装，限制类型用法；class 有运行时开销，适合复杂对象；extension 给已有类型加方法，不能加字段。
