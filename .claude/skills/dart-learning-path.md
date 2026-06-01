---
name: dart-learning-path
description: Dart 语言学习路径，从零基础到进阶，每课一个简单示例，逐层递进
---

# Dart 学习路径

## 学习原则

1. **每次一个知识点** — 不贪多，每课只引入一个新概念
2. **可运行的代码** — 每个知识点都有完整可运行的 `.dart` 文件
3. **对比中理解** — 新概念总与已学概念对比（`var vs final`、`extends vs implements vs with`）
4. **先问再教** — 先看代码输出，再解释原理
5. **疑问即重点** — 学习者的每个"为什么"都是深入理解的机会

## 阶段划分

### 第一阶段：基础语法（第1-9课）

**目标：** 能写一个简单的 Dart 程序

| 课 | 知识点 | 关键对比 |
|----|--------|----------|
| 1 | main 函数、print | — |
| 2 | 变量（var, int, double, String, bool） | `var` vs 显式类型 |
| 3 | 常量（final, const） | `var` vs `final` vs `const` |
| 4 | 运算符（算术/比较/逻辑） | `/` vs `~/` |
| 5 | 条件判断（if/else, 三元运算符） | if-else vs 三元 |
| 6 | 循环（for, while, for-in） | 三种循环的选用场景 |
| 7 | 函数（返回类型、箭头函数） | 普通函数 vs 箭头函数 |
| 8 | List 列表 | List vs（后续 Map） |
| 9 | Map 键值对 | List vs Map |

### 第二阶段：面向对象（第10-20课）

**目标：** 理解 Dart 的面向对象特性

| 课 | 知识点 | 关键对比 |
|----|--------|----------|
| 10 | 类与对象、this、构造函数 | — |
| 11 | 命名参数、可选参数、默认值 | 三种参数类型对比 |
| 12 | 空安全（?, ??, ?.） | — |
| 13 | 命名构造函数、初始化列表 | 普通 vs 命名构造函数 |
| 14 | 继承（extends, super） | 用继承 vs 不用继承 |
| 15 | 级联运算符（..） | `.` vs `..` |
| 16 | 抽象类（abstract） | 普通类 vs 抽象类 |
| 17 | implements 接口 | `extends` vs `implements` |
| 18 | Mixin 混入（with） | `extends` vs `implements` vs `with` |
| 19 | 泛型（T, K, V） | 泛型 vs dynamic |
| 20 | 枚举（enum） | 枚举 vs 字符串常量 |

### 第三阶段：现代 Dart 特性（第21-30课）

**目标：** 掌握 async 编程、Dart 3 特性和常用模式

| 课 | 知识点 | 关键对比 |
|----|--------|----------|
| 21 | async / await / Future | 同步 vs 异步 |
| 22 | Stream、yield | Future vs Stream |
| 23 | try/catch 异常处理 | 有 try-catch vs 没有 |
| 24 | Extension 扩展方法 | — |
| 25 | Record 记录 | Record vs 类 vs Map |
| 26 | sealed class 密封类 | sealed vs 普通抽象类 |
| 27 | 集合方法（where, map, reduce...） | — |
| 28 | factory 工厂构造函数 | 普通 vs factory |
| 29 | static 静态成员 | static vs 普通成员 |
| 30 | getter / setter | getter vs 普通方法 |

### 第四阶段：进阶主题（第31-40课）

**目标：** 掌握 Dart 进阶特性和并发编程

| 课 | 知识点 | 关键对比 |
|----|--------|----------|
| 31 | late 延迟初始化 | 普通属性 vs late |
| 32 | assert 断言 | assert vs if-throw |
| 33 | 模式匹配解构 | — |
| 34 | 运算符重载 | — |
| 35 | typedef 类型别名 | 不用 typedef vs 用 typedef |
| 36 | callable class | 函数 vs callable class |
| 37 | import 导入 | — |
| 38 | copyWith 不可变更新 | 直接改 vs copyWith |
| 39 | Isolate 并发 | Future vs Isolate |
| 40 | extension type | extension type vs class vs extension |

## 教学方法

### 每课结构

```dart
// 1. 可运行的完整代码
void main() {
  // 2. 输出结果写在注释里
  print(something);  // 结果
}

// 3. 关键概念在后面
```

### 对比教学法

对于容易混淆的概念，始终用对比表格：

```markdown
| | A | B |
|---|---|---|
| 写法 | ... | ... |
| 场景 | ... | ... |
```

### 常见疑问处理

学习过程中出现的疑问分类整理：
- 类型相关（double、void、sqrt）
- 参数相关（命名参数、可选参数、forEach 参数顺序）
- 面向对象相关（抽象类、接口、mixin、继承）
- 泛型相关（T、K、V、dynamic）
- 枚举相关（为什么不能用中文）
- 数据结构相关（Map vs Record vs 类）
- 常量相关（final vs const vs var）
- 并发相关（Isolate vs JS async）

## 最佳实践

### DO

- 每课只引入一个新概念，避免信息过载
- 新概念总与已学概念做对比
- 代码必须能直接 `dart run` 运行
- 用中文注释和命名降低理解门槛
- 鼓励学习者修改代码观察变化

### DON'T

- 不要一次给太多代码，控制在 20-40 行
- 不要跳过基础知识直接讲高级特性
- 不要用学习者还没学到的概念来解释新知识
- 不要忽略学习者的"为什么"——每个问题都是深入理解的机会

### 知识点时机

- 先讲 `var`，再讲 `final`/`const`（对比中理解）
- 先讲普通函数，再讲箭头函数（简写的前提是理解完整写法）
- 先讲 List/Map 使用，再讲泛型（先会用，再理解原理）
- 先讲 `extends`，再讲 `implements`，最后讲 `with`（逐步递进）
- 先讲 try-catch，再讲 async/await（先理解错误处理再理解异步）
