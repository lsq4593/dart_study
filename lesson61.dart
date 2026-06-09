// Dart 第六十一课：NoSuchMethod（拦截不存在的方法）

void main() {
  print('========== NoSuchMethod ==========');

  // ========== 1. 基本：拦截所有不存在的方法 ==========
  print('\n--- 1. 基本拦截 ---');
  dynamic proxy1 = Proxy();
  proxy1.sayHello('小明');
  proxy1.add(1, 2);
  proxy1.someMethod('a', 'b', 'c');

  // ========== 2. 按方法名分发 ==========
  print('\n--- 2. 按方法名分发 ---');
  dynamic router = RouterProxy();
  router.goHome();
  router.goUser(42);
  router.goSearch('dart', page: 1);
  router.unknownMethod();

  // ========== 3. 动态 Mock ==========
  print('\n--- 3. 动态 Mock ---');
  dynamic mock = MockService();
  mock.getUser(1);
  mock.saveUser({'name': '小明'});
  mock.deleteUser(5);
  print('  已调用方法: ${mock.calledMethods}');

  // ========== 4. 日志代理 ==========
  print('\n--- 4. 日志代理 ---');
  dynamic logger = LoggingProxy();
  logger.fetchData('https://api.example.com');
  logger.processOrder('ORD-001', 299.0);

  // ========== 5. 动态 API 客户端 ==========
  print('\n--- 5. 动态 API 客户端 ---');
  dynamic api = ApiProxy();
  api.users();
  api.posts(1);
  api.createUser({'name': '小明'});

  // ========== 6. Symbol 和 Invocation 深入 ==========
  print('\n--- 6. Symbol 和 Invocation ---');
  dynamic symbolDemo = SymbolProxy();
  symbolDemo.hello('world');
  symbolDemo.value = 42;

  // ========== 7. 不触发 noSuchMethod 的情况 ==========
  print('\n--- 7. 不触发的情况 ---');
  // 如果类型是具体的，不会触发 noSuchMethod
  Proxy proxy2 = Proxy();
  // proxy2.sayHello('你好');  // ❌ 编译报错！Proxy 没有 sayHello 方法

  // 只有在 dynamic 类型下，不存在的方法才会走 noSuchMethod
  dynamic proxy3 = Proxy();
  proxy3.anyMethod();  // ✅ 会触发

  print('\n程序结束');
}

// ========== 1. 基本拦截 ==========
class Proxy {
  @override
  void noSuchMethod(Invocation invocation) {
    print('  方法: ${invocation.memberName}');
    print('  参数: ${invocation.positionalArguments}');
    print('  ---');
  }
}

// ========== 2. 按方法名分发 ==========
class RouterProxy {
  @override
  void noSuchMethod(Invocation inv) {
    final name = inv.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');

    switch (name) {
      case 'goHome':
        print('  跳转到首页');
        break;
      case 'goUser':
        var id = inv.positionalArguments[0];
        print('  跳转到用户页, id=$id');
        break;
      case 'goSearch':
        var query = inv.positionalArguments[0];
        var page = inv.namedArguments[#page] ?? 1;
        print('  搜索: $query, 页码: $page');
        break;
      default:
        print('  未知路由: $name');
    }
  }
}

// ========== 3. 动态 Mock ==========
class MockService {
  final _called = <String>[];

  @override
  void noSuchMethod(Invocation inv) {
    final name = _methodName(inv);
    _called.add(name);
    print('  [Mock] $name ${inv.positionalArguments}');
  }

  String _methodName(Invocation inv) =>
    inv.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');

  List<String> get calledMethods => List.unmodifiable(_called);
}

// ========== 4. 日志代理 ==========
class LoggingProxy {
  @override
  void noSuchMethod(Invocation inv) {
    final name = _name(inv);
    final args = inv.positionalArguments;
    print('  [日志] 调用: $name');
    print('  [日志] 参数: $args');
    print('  [日志] 时间: ${DateTime.now()}');
  }

  String _name(Invocation inv) =>
    inv.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');
}

// ========== 5. 动态 API 客户端 ==========
class ApiProxy {
  @override
  void noSuchMethod(Invocation inv) {
    final name = _name(inv);
    final args = inv.positionalArguments;

    var url = StringBuffer('https://api.example.com');
    url.write('/$name');
    if (args.isNotEmpty) url.write('/${args[0]}');

    print('  [API] GET $url');
  }

  String _name(Invocation inv) =>
    inv.memberName.toString().replaceAll('Symbol("', '').replaceAll('")', '');
}

// ========== 6. Symbol 和 Invocation 深入 ==========
class SymbolProxy {
  @override
  void noSuchMethod(Invocation inv) {
    final name = inv.memberName;

    if (inv.isMethod) {
      print('  方法调用: $name, 参数: ${inv.positionalArguments}');
    } else if (inv.isGetter) {
      print('  getter: $name');
    } else if (inv.isSetter) {
      print('  setter: $name = ${inv.positionalArguments[0]}');
    }
  }
}

/*
总结：NoSuchMethod

1. 基本模式
   class MyClass {
     @override
     void noSuchMethod(Invocation inv) {
       // 拦截所有不存在的方法调用
     }
   }

2. Invocation 属性
   memberName           → 方法名（Symbol）
   positionalArguments  → 位置参数列表
   namedArguments       → 命名参数 Map
   isMethod / isGetter / isSetter → 调用类型

3. 必要条件
   - 必须用 dynamic 类型声明变量
   - 必须加 @override
   - 不处理的方法调 super.noSuchMethod(inv)

4. 用途
   - Mock 对象（测试）
   - 代理模式
   - 动态 API
   - 路由分发
*/
