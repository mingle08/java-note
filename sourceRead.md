![](D:\abc\giteeCode\java-note\2022-05-07-16-12-22-1651911072(1).jpg)

contents中是把mybatis中的sql解析成11个片段。执行完apply方法之后，context中的sqlBuilder的value如下：${}已经被解析，而#{}还没有解析。

![](D:\abc\giteeCode\java-note\2022-05-07-16-15-32-image.png)

${}符号在哪儿被替换的？是在IfSqlNode中替换的：

![](D:\abc\giteeCode\java-note\2022-05-07-18-30-17-image.png)

按F7跳转到TextSqlNode，在GenericTokenParser中完成替换。

![](D:\abc\giteeCode\java-note\2022-05-07-18-32-00-image.png)

```java
// 进入parse方法，来到SqlSourceBuilder类
public SqlSource parse(String originalSql, Class<?> parameterType, Map<String, Object> additionalParameters) {
  ParameterMappingTokenHandler handler = new ParameterMappingTokenHandler(configuration, parameterType, additionalParameters);
  GenericTokenParser parser = new GenericTokenParser("#{", "}", handler);
  String sql = parser.parse(originalSql);
  return new StaticSqlSource(configuration, sql, handler.getParameterMappings());
}
```

![](D:\abc\giteeCode\java-note\2022-05-07-16-23-17-image.png)

解析之后，#{}变成了问号。进入下一行的getBoundSql方法：

![](D:\abc\giteeCode\java-note\2022-05-07-16-26-05-image.png)

```java
// 最后来到BaseExecutor
public <E> List<E> query(MappedStatement ms, Object parameter, RowBounds rowBounds, ResultHandler resultHandler, CacheKey key, BoundSql boundSql) throws SQLException {
  ErrorContext.instance().resource(ms.getResource()).activity("executing a query").object(ms.getId());
  if (closed) throw new ExecutorException("Executor was closed.");
  if (queryStack == 0 && ms.isFlushCacheRequired()) {
    clearLocalCache();
  }
  List<E> list;
  try {
    queryStack++;
    list = resultHandler == null ? (List<E>) localCache.getObject(key) : null;
    if (list != null) {
      handleLocallyCachedOutputParameters(ms, key, parameter, boundSql);
    } else {
      list = queryFromDatabase(ms, parameter, rowBounds, resultHandler, key, boundSql);
    }
  } finally {
    queryStack--;
  }
  if (queryStack == 0) {
    for (DeferredLoad deferredLoad : deferredLoads) {
      deferredLoad.load();
    }
    deferredLoads.clear(); // issue #601
    if (configuration.getLocalCacheScope() == LocalCacheScope.STATEMENT) {
      clearLocalCache(); // issue #482
    }
  }
  return list;
}
```

![](D:\abc\giteeCode\java-note\2022-05-07-16-36-24-image.png)

最终走到PreparedStatementHandler类

![](D:\abc\giteeCode\java-note\2022-05-07-16-37-22-image.png)
