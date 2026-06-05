// Dart 第五十六课：Uri 类（URL 解析与构建）

void main() {
  print('========== Uri 类 ==========');

  // ========== 1. 解析 URL ==========
  print('\n--- 1. 解析 URL ---');
  var uri = Uri.parse('https://user:pass@example.com:8080/path/to/page?name=dart&version=3.0&page=1#section2');

  print('scheme:   ${uri.scheme}');     // https
  print('host:     ${uri.host}');       // example.com
  print('port:     ${uri.port}');       // 8080
  print('userInfo: ${uri.userInfo}');   // user:pass
  print('path:     ${uri.path}');       // /path/to/page
  print('query:    ${uri.query}');      // name=dart&version=3.0&page=1
  print('fragment: ${uri.fragment}');   // section2

  // queryParameters 返回 Map
  print('query参数:');
  uri.queryParameters.forEach((k, v) {
    print('  $k = $v');
  });

  // ========== 2. 构建 URL ==========
  print('\n--- 2. 构建 URL ---');

  // 基本构建
  var url1 = Uri(
    scheme: 'https',
    host: 'api.example.com',
    path: '/v2/users',
    queryParameters: {'page': '1', 'size': '20'},
  );
  print('构建URL: $url1');

  // 带端口
  var url2 = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 3000,
    path: '/api/data',
  );
  print('本机服务: $url2');

  // 带 fragment
  var url3 = Uri(
    scheme: 'https',
    host: 'flutter.dev',
    path: '/docs',
    fragment: 'overview',
  );
  print('带锚点: $url3');

  // ========== 3. 编码与解码 ==========
  print('\n--- 3. 编码与解码 ---');

  // 编码：中文/特殊字符 → 百分号编码
  var encoded = Uri.encodeComponent('你好世界');
  print('编码中文: $encoded');

  // 解码：百分号编码 → 原始字符
  var decoded = Uri.decodeComponent(encoded);
  print('解码回来: $decoded');

  // 编码完整的 URL（保留 :// 等）
  var fullUri = Uri.encodeFull('https://example.com/路径?查询=值');
  print('编码完整URL: $fullUri');

  // ========== 4. 相对路径与绝对路径 ==========
  print('\n--- 4. 相对路径解析 ---');

  // Uri.base 是当前脚本所在的目录
  var base = Uri.base;
  print('当前base: $base');

  // 相对于 base 解析路径
  var resolved = base.resolve('../other/file.txt');
  print('相对路径解析: $resolved');

  // 也可以手动指定 base
  var base2 = Uri.parse('https://example.com/a/b/');
  print('从base解析: ${base2.resolve('../c/file.txt')}');

  // ========== 5. 判断 URL 类型 ==========
  print('\n--- 5. 判断 URL 类型 ---');

  void checkUri(String urlStr) {
    var u = Uri.tryParse(urlStr);
    if (u == null) {
      print('  "$urlStr" → 非法URL');
      return;
    }
    print('  "$urlStr"');
    print('    scheme: ${u.scheme}');
    print('    isAbsolute: ${u.isAbsolute}');
    print('    hasScheme: ${u.hasScheme}');
    print('    hasQuery: ${u.hasQuery}');
    print('    hasFragment: ${u.hasFragment}');
  }

  checkUri('https://example.com');
  checkUri('ftp://files.example.com/repo');
  checkUri('mailto:user@example.com');
  checkUri('file:///C:/Users/test.txt');
  checkUri('just a string');
  checkUri('/relative/path');

  // ========== 6. 修改 URL 的某部分 ==========
  print('\n--- 6. 修改 URL 的部分 ---');

  var original = Uri.parse('https://example.com/search?q=dart');
  print('原始: $original');

  // 替换某些部分
  var modified = original.replace(
    host: 'api.example.com',
    queryParameters: {'q': 'flutter', 'sort': 'asc'},
  );
  print('修改后: $modified');

  // 只改路径
  var newPath = original.replace(path: '/v2/search');
  print('改路径: $newPath');

  // ========== 7. 拼接路径 ==========
  print('\n--- 7. 路径拼接 ---');

  var api = Uri.parse('https://api.example.com');
  var usersPath = api.replace(path: '/users');
  var userDetail = usersPath.replace(path: '/users/42');
  print('api:    $api');
  print('列表:   $usersPath');
  print('详情:   $userDetail');

  // 更优雅的方式
  var endpoint = Uri.parse('https://api.example.com');
  var list = endpoint.resolve('/users');
  var detail = endpoint.resolve('/users/42');
  print('resolve列表: $list');
  print('resolve详情: $detail');

  // ========== 8. 实际场景：从复杂 URL 提取信息 ==========
  print('\n--- 8. 实际场景 ---');

  // 场景：从 API 响应中的 URL 提取 ID
  var apiUrl = Uri.parse('https://api.github.com/repos/dart-lang/sdk/issues/54321');
  var segments = apiUrl.pathSegments;
  print('路径分段: $segments');
  print('最后一段(id): ${segments.last}');

  // 场景：检查是否为某个域名
  var requestUri = Uri.parse('https://www.google.com/search?q=dart');
  print('是google吗: ${requestUri.host.contains('google.com')}');

  // 场景：从 Referer 提取来源
  var referer = Uri.parse('https://example.com/products?category=books');
  print('Referer来源: ${referer.host}');
  print('来源分类: ${referer.queryParameters['category']}');

  // 场景：数据 URI
  var dataUri = Uri.parse('data:text/plain;base64,SGVsbG8=');
  print('数据URI scheme: ${dataUri.scheme}');  // data
  print('数据URI path: ${dataUri.path}');  // text/plain;base64,SGVsbG8=

  // ========== 9. 处理查询参数 ==========
  print('\n--- 9. 处理查询参数 ---');

  // 构建复杂查询
  var searchUri = Uri(
    scheme: 'https',
    host: 'search.example.com',
    path: '/api',
    queryParameters: {
      'q': 'dart language',
      'page': '1',
      'sort': 'relevance',
      'filter': '{"lang":"zh","year":2024}',
    },
  );
  print('搜索URL: $searchUri');

  // 修改查询参数
  var nextPage = searchUri.replace(
    queryParameters: {
      ...searchUri.queryParameters,
      'page': '2',  // 只翻页
    },
  );
  print('下一页: $nextPage');

  print('\n程序结束');
}

/*
总结：Uri 类

1. 解析
   Uri.parse('url字符串')        → 分解出 scheme/host/path/query...
   Uri.tryParse('url字符串')     → 解析失败返回 null（不抛异常）

2. 构建
   Uri(scheme: 'https', host: '...', path: '/...', queryParameters: {...})

3. 编码
   Uri.encodeComponent('中文')   → 对单个值编码
   Uri.encodeFull('url')         → 编码整个 URL（保留 ://）
   Uri.decodeComponent(...)      → 解码

4. 路径操作
   uri.resolve('../other')       → 相对路径解析
   uri.replace(path: '/new')     → 替换某部分
   uri.pathSegments              → 路径分段列表

5. 判断
   uri.isAbsolute                → 是否是绝对 URL
   uri.hasScheme / hasQuery / hasFragment
*/
