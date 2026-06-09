// Dart 第六十三课：注解（Annotations / 元数据）

import 'dart:mirrors';

void main() {
  print('========== 注解 ==========');

  // ========== 1. 读取类上的注解 ==========
  print('\n--- 1. 读取类注解 ---');
  // reflectClass() 获取 UserService 类的镜像（反射入口）
  var classMirror = reflectClass(UserService);
  // metadata 包含了该类上所有的注解实例
  for (var m in classMirror.metadata) {
    // 判断注解类型是否为 Route（用 is 关键字）
    if (m.reflectee is Route) {
      // 将注解对象转为 Route 类型，读取 path 属性
      var route = m.reflectee as Route;
      print('  UserService 路由: ${route.path}');
    }
  }

  // ========== 2. 读取方法上的注解 ==========
  print('\n--- 2. 读取方法注解 ---');
  var methods = classMirror.declarations.values.whereType<MethodMirror>();
  print('${methods}什么啊');
  for (var method in methods) {
    var methodName = MirrorSystem.getName(method.simpleName);
    for (var m in method.metadata) {
      if (m.reflectee is Route) {
        var route = m.reflectee as Route;
        print('  ${methodName} → ${route.method} ${route.path}');
      }
      if (m.reflectee is NeedAuth) {
        print('  ${methodName} → 需要登录');
      }
    }
  }

  // ========== 3. 读取字段上的注解 ==========
  print('\n--- 3. 读取字段注解 ---');
  var formMirror = reflectClass(LoginForm);
  // 遍历字段
  formMirror.declarations.forEach((name, decl) {
    if (decl is VariableMirror) {
      var fieldName = MirrorSystem.getName(name);
      for (var m in decl.metadata) {
        if (m.reflectee is Required) {
          print('  ${fieldName} → 必填');
        }
        if (m.reflectee is Range) {
          var range = m.reflectee as Range;
          print('  ${fieldName} → 范围: ${range.min}-${range.max}');
        }
      }
    }
  });

  // ========== 4. 运行时校验示例 ==========
  print('\n--- 4. 运行时校验 ---');
  var validator = Validator();
  var form = LoginForm();

  form.username = 'ab'; // 太短
  form.password = '123456789'; // 可以
  form.age = 200; // 超出范围

  var errors = validator.validate(form);
  if (errors.isEmpty) {
    print('  校验通过');
  } else {
    for (var e in errors) {
      print('  ❌ $e');
    }
  }

  // ========== 5. 内置注解 @deprecated ==========
  print('\n--- 5. 内置注解 ---');
  // @override ← 重写父类方法
  // @deprecated ← 标记为已废弃
  // @pragma('vm:entry-point') ← VM 相关
  // @Deprecated('原因') ← 带说明的废弃标记

  print('  @override    — 重写父类方法');
  print('  @deprecated  — 已废弃（无说明）');
  print('  @Deprecated  — 已废弃（带说明）');

  // ========== 6. 自定义注解 + 组合 ==========
  print('\n--- 6. 自定义注解组合 ---');

  // 模拟 API 文档自动生成
  var apiMirror = reflectClass(OrderApi);
  apiMirror.declarations.forEach((name, decl) {
    if (decl is MethodMirror) {
      var methodName = MirrorSystem.getName(name);
      var parts = <String>['  方法: $methodName'];

      for (var m in decl.metadata) {
        if (m.reflectee is ApiDoc) {
          parts.add('    说明: ${(m.reflectee as ApiDoc).desc}');
        }
        if (m.reflectee is Route) {
          var r = m.reflectee as Route;
          parts.add('    路由: ${r.method} ${r.path}');
        }
        if (m.reflectee is NeedAuth) {
          parts.add('    权限: 需要登录');
        }
      }

      for (var p in parts) {
        print(p);
      }
    }
  });

  print('\n程序结束');
}

// ========== 定义注解类 ==========
// 注解类构造函数必须 const

class Route {
  final String method;
  final String path;
  const Route(this.method, this.path);
}

class NeedAuth {
  const NeedAuth();
}

class Required {
  const Required();
}

class Range {
  final int min;
  final int max;
  const Range({this.min = 0, this.max = 100});
}

class Length {
  final int min;
  final int max;
  const Length({this.min = 0, this.max = 100});
}

class ApiDoc {
  final String desc;
  const ApiDoc(this.desc);
}

// ========== 使用注解 ==========

@Route('/users', 'GET')
class UserService {
  @Route('/list', 'GET')
  @NeedAuth()
  void getUsers() {}

  @Route('/create', 'POST')
  @ApiDoc('创建新用户')
  @NeedAuth()
  void createUser() {}

  @Route('/login', 'POST')
  void login() {}
}

class LoginForm {
  @Required()
  @Length(min: 3, max: 20)
  String? username;

  @Required()
  @Length(min: 6, max: 32)
  String? password;

  @Range(min: 0, max: 150)
  int age = 0;
}

// ========== 注解校验器 ==========
class Validator {
  List<String> validate(Object obj) {
    var errors = <String>[];
    var mirror = reflect(obj);
    var classMirror = mirror.type;

    classMirror.declarations.forEach((name, decl) {
      if (decl is VariableMirror) {
        var fieldName = MirrorSystem.getName(name);
        var fieldMirror = mirror.getField(name);
        var value = fieldMirror.reflectee;

        for (var ann in decl.metadata) {
          var annotation = ann.reflectee;

          if (annotation is Required && value == null) {
            errors.add('$fieldName 为必填');
          }

          if (annotation is Length && value is String) {
            var len = annotation as Length;
            if (value.length < len.min || value.length > len.max) {
              errors.add('$fieldName 长度应在 ${len.min}-${len.max} 之间');
            }
          }

          if (annotation is Range && value is int) {
            var range = annotation as Range;
            if (value < range.min || value > range.max) {
              errors.add('$fieldName 应在 ${range.min}-${range.max} 之间');
            }
          }
        }
      }
    });

    return errors;
  }
}

// ========== 带注解的 API 类 ==========
class OrderApi {
  @ApiDoc('获取订单列表')
  @Route('/orders', 'GET')
  @NeedAuth()
  void getOrders() {}

  @ApiDoc('创建订单')
  @Route('/orders', 'POST')
  @NeedAuth()
  void createOrder() {}

  @ApiDoc('取消订单')
  @Route('/orders/{id}', 'DELETE')
  @NeedAuth()
  void cancelOrder() {}

  @Route('/health', 'GET')
  void healthCheck() {}
}

/*
总结：注解

1. 定义注解类
   class MyAnnotation {
     final String value;
     const MyAnnotation(this.value);  // 必须 const
   }

2. 使用注解
   @MyAnnotation('说明')
   class MyClass { }

3. 读取注解（需 dart:mirrors）
   reflectClass(MyClass).metadata  → 注解列表
   reflect(MyClass).type.declarations → 字段/方法
   每个 decl.metadata → 该成员的注解

4. 用途
   - 路由定义（@Route('/users', 'GET')）
   - 参数校验（@Required, @Range）
   - API 文档（@ApiDoc）
   - 权限控制（@NeedAuth）
   - 代码生成（json_serializable, freezed）

5. 注意
   - 构造函数必须 const
   - dart:mirrors 在 Flutter/Web 不可用
   - 生产环境多用代码生成替代反射
*/
