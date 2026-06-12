// Dart 全课程综合练习题 — 第19题
// 知识点：注解（Annotations）、反射

import 'dart:mirrors';

// TODO:
// 1. 定义注解 @Route(path: '/users')
// 2. 定义注解 @GET / @POST
// 3. 在类和方法上使用注解
// 4. 用反射读取注解信息，打印路由表

class Route {
  final String path;
  const Route(this.path);
}

class GET {
  const GET();
}

class POST {
  const POST();
}

// 使用注解
@Route('/users')
class UserController {
  @GET()
  void listUsers() {}

  @POST()
  void createUser() {}
}

@Route('/articles')
class ArticleController {
  @GET()
  void listArticles() {}

  @GET()
  void getArticle() {}

  @POST()
  void createArticle() {}
}

// TODO: 用反射读取并打印路由表
void printRoutes() {
  // - 扫描所有类
  // - 检查是否有 @Route 注解
  // - 检查方法是否有 @GET / @POST 注解
  // - 打印格式: GET /users UserController.listUsers
}

void main() {
  printRoutes();
  // 期望输出:
  // GET  /users        UserController.listUsers
  // POST /users        UserController.createUser
  // GET  /articles     ArticleController.listArticles
  // GET  /articles     ArticleController.getArticle
  // POST /articles     ArticleController.createArticle
}
