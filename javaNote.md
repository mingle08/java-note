### 1，CAS的问题

（1）只能操作一个变量

（2）ABA问题

（3）CPU开销问题

### 2，CPU指令环

Intel的CPU将特权级别分为4个级别：RING0,RING1,RING2,RING3。

Windows只使用其中的两个级别RING0和RING3，RING0只给操作系统用，RING3谁都能用。如果普通应用程序企图执行RING0指令，则Windows会显示“非法指令”错误信息。

ring0是指CPU的运行级别，ring0是最高级别，ring1次之，ring2更次之……

### 3，垃圾回收器

（1）Serial收集器 + Serial Old收集器

（2）ParNew收集器：Serial收集器的多线程版本

（3）Parallel Scavenge收集器 + Parallel Old收集器

（4）CMS：concurrent mark sweep

​    a. 对CPU资源敏感（会和服务抢资源）

​    b. 无法处理浮动垃圾，有可能出现“Concurrent Mode Failure"失败进而导致另一次完全"stop the world"的Full GC的产生，临时启用Serial Old收集器来重新进行老年代的垃圾收集，但这样停顿时间就很长了

​    c. 大量空间碎片的产生

### 4，CMS收集器

（1）初始标记

（2）并发标记

（3）重新标记

（4）并发清除

### 5，三色标记

漏标，两种解决方案：增量更新，原始快照SATB

增量更新：黑色对象一旦新插入了指向白色对象的引用之后，它就变回灰色对象了

SATB：无论引用关系删除与否，都会按照刚刚开始扫描那一刻的对象图快照来进行搜索

### 6，G1收集器

（1）初始标记

（2）并发标记：同CMS的并发标记

（3）最终标记：同CMS的重新标记

（4）筛选回收

### 7，ZGC收集器

（1）并发标记

（2）并发预备重分配

（3）并发重分配

（4）并发重映射

### 8，推荐用自定义的线程池

```java
/** 
FixedThreadPool和SingleThreadPool使用的队列是LinkedBlockingQueue,这是无界队列，允许请求的最大长度为：Integer.MAX_VALUE，
可能会堆积大量的请求，从而导致OOM
*/
public static ExecutorService newFixedThreadPool(int nThreads) {
    return new ThreadPoolExecutor(nThreads, nThreads, 
                                  0L, TimeUnit.MILLISECONDS, 
                                  new LinkedBlockingQueue<Runnable>());
}

public static ExecutorService newSingleThreadExecutor() {
    return new FinalizableDelegatedExecutorService
        (new ThreadPoolExecutor(1, 1,
                                0L, TimeUnit.MILLISECONDS,
                                new LinkedBlockingQueue<Runnable>()));
}

/**
看看LinkedBlockingQueue的容量大小：Integer.MAX_VALUE
*/
public LinkedBlockingQueue() {
    this(Integer.MAX_VALUE);
}



/**
CachedThreadPool和ScheduleThreadPool允许的创建线程数量为：Integer.MAX_VALUE，可能会创建大量的线程，从而导致OOM
*/
public static ExecutorService newCachedThreadPool() {
    return new ThreadPoolExecutor(0, Integer.MAX_VALUE,
                                      60L, TimeUnit.SECONDS,
                                      new SynchronousQueue<Runnable>());
}

public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize) {
    return new ScheduledThreadPoolExecutor(corePoolSize);
}

// ScheduledThreadPoolExecutor类
public ScheduledThreadPoolExecutor(int corePoolSize) {
    super(corePoolSize, Integer.MAX_VALUE, 0, NANOSECONDS,
          new DelayedWorkQueue());
}

/**
线程池参数分析
corePoolSize : 核心线程数
maximumPoolSize : 最大线程数
keepAliveTime : 非核心线程的超时时长,如果非核心线程闲置时间超过keepAliveTime之后，就会被回收。如果设置allowCoreThreadTimeOut为true，则该参数也表示           核心线程的超时时长
unit : 超时时长单位
workQueue : 线程池中的任务队列，该队列主要用来存储已经被提交但是尚未执行的任务
handler : 拒绝策略
*/
public ThreadPoolExecutor(int corePoolSize,
        int maximumPoolSize,
        long keepAliveTime,
        TimeUnit unit,
        BlockingQueue<Runnable> workQueue,
        RejectedExecutionHandler handler)
```

### 9，HashMap中能保证有序的是哪个Map ？

```java
/**
The iteration ordering method for this linked hash map: true for access-order, false for insertion-order.
true 访问顺序，false 插入顺序
*/
final boolean accessOrder;
```

### 10，Spring的事务传播和隔离级别有哪些？

查看Spring的Propagation枚举类：

```java
public enum Propagation {

   REQUIRED(TransactionDefinition.PROPAGATION_REQUIRED),

   SUPPORTS(TransactionDefinition.PROPAGATION_SUPPORTS),

   MANDATORY(TransactionDefinition.PROPAGATION_MANDATORY),

   REQUIRES_NEW(TransactionDefinition.PROPAGATION_REQUIRES_NEW),

   NOT_SUPPORTED(TransactionDefinition.PROPAGATION_NOT_SUPPORTED),

   NEVER(TransactionDefinition.PROPAGATION_NEVER),

   NESTED(TransactionDefinition.PROPAGATION_NESTED);

   private final int value;

   Propagation(int value) {
      this.value = value;
   }

   public int value() {
      return this.value;
   }

}

// 查看org.springframework.transaction.TransactionDefinition   
int PROPAGATION_REQUIRED = 0;

int PROPAGATION_SUPPORTS = 1;

int PROPAGATION_MANDATORY = 2;

int PROPAGATION_REQUIRES_NEW = 3;

int PROPAGATION_NOT_SUPPORTED = 4;

int PROPAGATION_NEVER = 5;

int PROPAGATION_NESTED = 6;

int ISOLATION_DEFAULT = -1;

int ISOLATION_READ_UNCOMMITTED = Connection.TRANSACTION_READ_UNCOMMITTED;

int ISOLATION_READ_COMMITTED = Connection.TRANSACTION_READ_COMMITTED;

int ISOLATION_REPEATABLE_READ = Connection.TRANSACTION_REPEATABLE_READ;

int ISOLATION_SERIALIZABLE = Connection.TRANSACTION_SERIALIZABLE;

int TIMEOUT_DEFAULT = -1;

int getPropagationBehavior();

int getIsolationLevel();

int getTimeout();

boolean isReadOnly();

String getName();

// 隔离级别，java.sql.Connection
int TRANSACTION_NONE             = 0;

int TRANSACTION_READ_UNCOMMITTED = 1;

int TRANSACTION_READ_COMMITTED   = 2;

int TRANSACTION_REPEATABLE_READ  = 4;

int TRANSACTION_SERIALIZABLE     = 8;
```

### 11，死锁

（1）产生死锁必须具备以下4个条件

**互斥**

**请求与保持**

**不剥夺**

**循环等待**

（2）避免死锁

**破坏互斥**   无法破坏

**破坏请求与保持**  一次性申请所有的资源

**破坏不剥夺**  占用部分资源的线程，进一步申请其他资源时，如果申请不到，可以主动释放已占有的资源

**破坏循环等待**  按序申请资源

### 12，Raft选举算法

（1）节点A发生故障，节点B和节点C没有收到领导者节点A的心跳信息，等待超时

（2）节点C（175 ms）先发生超时，节点C成为候选人。

（3）节点C向节点A和节点B发起请求投票信息

（4）节点B响应投票，将票投给了C，而节点A因为发生故障，无法响应C的投票请求

（5）节点C收到2票（大多数票数），成为新的领导者

（6）节点C向节点A和节点B发送心跳信息，节点B响应心跳信息，节点A不响应心跳信息

（7）节点A恢复后，收到节点C的高任期消息，自身将成为跟随者，接收节点C的消息

### 13，Raft算法的几个关键机制

（1）任期机制

（2）领导者心跳信息

（3）随机选举的超时时间

（4）先来先服务的投票原则

（5）大多数选票原则

### 14，HashMap的put方法

```java
final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
    Node<K,V>[] tab; Node<K,V> p; int n, i;
    // 懒加载：table一开始并未初始化或者长度为0，在put元素之后才加载
    if ((tab = table) == null || (n = tab.length) == 0)
        n = (tab = resize()).length;
    /** 
    (n - 1) & hash 确定元素存放在哪个桶中，桶为空，新生成结点放入桶中(此时，这个结点是放在数组中)
    哈希值赋值给i，tab[i]赋值给p，即 p = tab[i = (n - 1) & hash]，虽然是在if分支里，但p变量在方法内第一行，所以能在后续else中使用
    相当于在if之前赋值，if和else都能使用此赋值
    p = tab[i = (n - 1) & hash];
    if (p == null)
        tab[i] = newNode(hash, key, value, null);
    else {
        ......
    }
    */
    if ((p = tab[i = (n - 1) & hash]) == null)
        tab[i] = newNode(hash, key, value, null);
    // 桶中已经存在元素：hash值相同
    else {
        Node<K,V> e; K k;
        // 比较桶中第一个元素(数组中的结点), 如果hash值相等，key相等
        if (p.hash == hash &&
            ((k = p.key) == key || (key != null && key.equals(k))))
                // 将第一个元素赋值给e，用e来记录，后面将e进行旧值覆盖
                e = p;
        // key不相等且为红黑树结点
        else if (p instanceof TreeNode)
            // 放入树中
            e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
        // 为链表结点
        else {
            // 在链表最末插入结点
            for (int binCount = 0; ; ++binCount) {
                // 到达链表的尾部
                if ((e = p.next) == null) {
                    // 在尾部插入新结点
                    p.next = newNode(hash, key, value, null);
                    // 结点数量达到阈值，转化为红黑树
                    if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                        treeifyBin(tab, hash);
                    // 跳出循环
                    break;
                }
                // 判断链表中结点的key值与插入的元素的key值是否相等
                if (e.hash == hash &&
                    ((k = e.key) == key || (key != null && key.equals(k))))
                    // 相等，跳出循环，等待后续操作覆盖旧值
                    break;
                // 用于遍历桶中的链表，与前面的e = p.next组合，可以遍历链表
                p = e;
            }
        }
        // 表示在桶中找到key值、hash值与插入元素相等的结点，进行旧值覆盖
        if (e != null) { 
            // 记录e的value
            V oldValue = e.value;
            // onlyIfAbsent为false或者旧值为null
            if (!onlyIfAbsent || oldValue == null)
                //用新值替换旧值
                e.value = value;
            // 访问后回调
            afterNodeAccess(e);
            // 返回旧值
            return oldValue;
        }
    }
    // 结构性修改
    ++modCount;
    // 实际大小大于阈值则扩容
    if (++size > threshold)
        resize();
    // 插入后回调
    afterNodeInsertion(evict);
    return null;
}
```

### 15，GC Root对象有哪些

（1）虚拟机栈（栈桢中的本地变量表）中引用的对象

（2）方法区中类静态属性引用的对象

（3）方法区中常量引用的对象

（4）本地方法栈中JNI即一般说的native方法引用的对象

（5）Java虚拟机内部的引用：基本数据类型对应的Class对象，一些常驻的异常对象（比如NullPorintException, OutOfMemeryError）等，还有系统类加载器

（6）所有被同步锁（synchronized关键字）持有的对象

（7）反映Java虚拟机内部的JMXBean, JVMTI中注册的回调、本地代码缓存等

### 16，引用的分类

（1）强引用

（2）软引用：内存不够时，会被回收

（3）弱引用：不管内存够不够用，都会被回收

（4）虚引用

### 17，不再被使用的类

（1）该类所有的实例都已经被回收

（2）加载该类的类加载器已被回收

（3）该类对应的java.lang.Class对象没有任何地方引用

### 18，跳跃表

#### （1）Redis中的实现

​    Server.h类中的zskiplist

#### （2）JDK中的实现

​    ConcurrentSkipListMap.java

![](D:\abc\giteeCode\java-note\跳跃表.png)

### 19，dubbo的整体架构设计和分层

#### （1）5个角色<br>

* 注册中心registry：服务注册与发现<br>

* 服务提供者provider：暴露服务<br>

* 服务消费者consumer：调用远程服务<br>

* 监控中心monitor：统计服务的调用次数和调用时间<br>

* 窗口container：服务允许窗口<br>

#### （2）调用流程<br>

* container容器负责启动、加载、运行provider<br>

* provider在启动时，向registry中心注册自己提供的服务<br>

* consumer在启动时，向registry中心订阅自己所需的服务<br>

* registry返回服务提供者列表给consumer，如果有变更，registry将基于长连接发送变更给consumer<br>

* consumer调用provider服务，基于负载均衡算法进行调用<br>

* consumer调用provider的统计，基于短连接定时每分钟一次统计到monitor<br>

#### （3）分层<br>

* 接口服务层（Service）：面向开发者、业务代码、接口、实现等<br>

* 配置层（Config）：对外配置接口，以ServiceConfig与ReferenceConfig为中心<br>

* 服务代理层（Proxy）：对生产者和消费者、dubbo都会产生一个代理类封装调用细节，业务层对调用细节无感<br>

* 服务注册层（Registry）：封装服务地址的注册与发现，以服务URL为中心<br>

* 路由层（Cluster）：封装多个提供者的路由和负载均衡，并桥接注册中心<br>

* 监控层（Monitor）：RPC调用次数和调用时间监控<br>

* 远程调用层（Protocol）：封装RPC调用<br>

* 信息交换层（Exchange）：封装请求响应模式，同步转异步<br>

* 网络传输层（Transport）：抽象mina和netty为统一接口，统一网络传输接口<br>

* 数据序列化层（Serialize）：数据传输的序列化和反序列化<br>

### 20，ZAB协议与RAFT协议的区别

#### （1）ZAB<br>

* Leader 一个zookeeper集群同一时刻仅能有一个Leader。Leader负责接收所有的客户端的请求。<br>
* Follower 提供读服务，参与选举。<br>
* Observer 仅提供读服务。<br>

#### （2）Raft<br>

* Leader 负责接收所有的客户端的请求。<br>
* Follower 读写请求都转发到Leader，参与选举。<br>
* Candidate 每个节点上都有一个倒计时器 (Election Timeout)，时间随机在 150ms 到 300ms 之间。在一个节点倒计时结束 (Timeout) 后，这个节点的状态变成 Candidate 开始选举，它给其他几个节点发送选举请求 (RequestVote)。选举成功则变为Leader。<br>

### 21，缓存雪崩、缓存穿透、缓存击穿

#### （1）缓存雪崩

同一时间缓存大面积失效，导致后面的请求都会落到数据库上，造成数据库短时间内承受大量请求而崩掉

#### 解决方案

* 缓存数据的过期时间设置随机，防止同一时间大量数据过期现象发生
* 给每一个缓存数据增加相应的缓存标记，记录缓存是否失效，如果缓存标记失效，则更新数据的缓存
* 缓存预热
* 互斥锁

#### （2）缓存穿透

缓存和数据库中都没有的数据，导致所有的请求都落到数据库上，造成数据库短时间内承受大量请求而崩掉

#### 解决方案：

* 接口层增加校验，如用户鉴权校验，id做基础校验，id<=0的直接拦截
* 从缓存取不到的数据，在数据库中也没有取到，这时也可以将key-value写为key-null，缓存有效时间可以设置短一点，比如30秒（设置太长会导致正常情况也没法使用）。这样可以防止攻击用户反复用同一个id暴力攻击
* 采用布隆过滤器，将所有可能存在的数据哈希到一个足够大的bitmap中，一个一定不存在的数据会被这个bitmap拦截掉，从而避免了对底层存储系统的查询压力

#### （3）缓存击穿

缓存中没有，但数据库中有的数据（一般是缓存时间到期），这时并发用户特别多，同时读缓存没读到数据，又数据库取数据，引起数据库压力瞬间增大，造成过大压力。和缓存雪崩不同的是，缓存击穿指并发查同一条数据，缓存雪崩是不同数据都过期了，很多数据都查不到从而查数据库

#### 解决方案

* 设置热点数据永远不过期
* 互斥锁

### 22，JVM性能监控工具

* jps
  
  ```
  jps -l
  ```

* jstat
  
  ```
  jstat -gc 2764 250 20
  ```

* jmap
  
  ```
  jmap -heap 158
  ```

* jstack
  
  ```
  jstack -l 3500
  ```

### 23，主动调用gc的方法

```java
System.gc();

// 源码
public static void gc() {
  Runtime.getRuntime().gc();
}
```

### 24，gitee开源许可证怎么选

![](D:\abc\giteeCode\java-note\开源许可证.png)

参考：[代码开源如何选择开源许可证_JackieDYH的博客-CSDN博客_gitee开源许可证选哪个](https://blog.csdn.net/JackieDYH/article/details/105800230?utm_term=%E6%80%8E%E4%B9%88%E9%80%89%E6%8B%A9gitte%E7%9A%84%E5%BC%80%E6%BA%90%E8%AE%B8%E5%8F%AF%E8%AF%81&utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduweb~default-1-105800230&spm=3001.4430)

### 25，dubbo服务暴露和服务消费机制

![](assets/2022-04-19-00-12-06-image.png)

### 26，dubbo协议的魔数

```java
public class ExchangeCodec extends TelnetCodec {

    // header length.
    protected static final int HEADER_LENGTH = 16;
    // magic header.
    protected static final short MAGIC = (short) 0xdabb;
    protected static final byte MAGIC_HIGH = Bytes.short2bytes(MAGIC)[0];
    protected static final byte MAGIC_LOW = Bytes.short2bytes(MAGIC)[1];
    // 省略其它代码
}
```

### 27，dubbo protocol继承图

![](assets/2022-04-19-00-54-16-image.png)

### 28，dubbo服务暴露代码分析

```java
export()
--> ServiceConfig.export()
--> doExport()
--> doExportUrls()
--> loadRegistries(true)
--> doExportFor1Protocol(ProtocolConfig protocolConfig, List<URL> registryURLs)
--> exportLocal(URL url)
--> proxyFactory.getInvoker(ref, (Class) interfaceClass, local)
--> ExtensionLoader.getExtensionLoader(ProxyFactory.class).getExtension("javassist")
--> extension.getInvoker(arg0, arg1, arg2)
--> StubProxyFactoryWrapper.getInvoker(T proxy, Class<T> type, URL url)
...
```

### 29，泛型

1，ParameterizedType

```
Set<String> set;
Class<Integer> clazz;
MyClass<String> myClass;
List<String> list;
class MyClass<V>{

}
```

2，TypeVariable

```
<T extends KnownType-1 & KnownType-2>

public interface TypeVariable<D extends GenericDeclaration> extends Type {

   //获得泛型的上限，若未明确声明上边界则默认为Object
    Type[] getBounds();

    //获取声明该类型变量实体(即获得类、方法或构造器名)
    D getGenericDeclaration();

    //获得名称，即K、V、E之类名称
    String getName();

    //获得注解类型的上限，若未明确声明上边界则默认为长度为0的数组
    AnnotatedType[] getAnnotatedBounds()

}
```

3，WildcardType

```
<? extends Number>
```

4，GenericArrayType

```
List<String>[] listArray; //是GenericArrayType,元素是List<String>类型，也就是ParameterizedType类型

T[] tArray; //是GenericArrayType,元素是T类型，也就是TypeVariable类型


Person[] persons; //不是GenericArrayType

List<String> strings; //不是GenericArrayType
```

### 30，hotspot源码中的juint类型

```cpp
// globalDefinitions_visCPP.hpp

// Additional Java basic types

typedef unsigned char    jubyte;
typedef unsigned short   jushort;
typedef unsigned int     juint;
typedef unsigned __int64 julong;
```

### 31，堆转储的转储是什么意思

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-04-30-19-17-42-image.png)

### 32，Hotspot中定义的5种对象状态

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-04-30-19-36-45-image.png)

### 33，JVM内部定义的类状态

```cpp
// hotspot/src/share/vm/oops/instanceKlass.hpp

// See "The Java Virtual Machine Specification" section 2.16.2-5 for a detailed description
// of the class loading & initialization procedure, and the use of the states.
enum ClassState {
  allocated,                          // allocated (but not yet linked)
  loaded,                             // loaded and inserted in class hierarchy (but not linked yet)
  linked,                             // successfully linked/verified (but not initialized yet)
  being_initialized,                  // currently running class initializer
  fully_initialized,                  // initialized (successfull final state)
  initialization_error                // error happened during initialization
};
```

### 34，spring源码编译，版本号：4.3.18

* 命令：./gradlew :spring-oxm:compileTestJava  编译成功

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-01-13-27-01-image.png)

* sync 成功

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-01-16-20-04-image.png)

### 35，调试循环依赖

（1）配置文件和依赖bean的准备

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-18-47-34-image.png)

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-18-48-16-image.png)

Class B的内容类似A，这里省略。

（2）开始调试，一直进入到refresh()方法 --> finishBeanFactoryInitialization --> preInstantiateSingletons()方法

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-18-46-33-image.png)

可以看到，要实例化的beanNames有2个，就是我们想要的a和b。

首先是处理a，重点关注bd即beanDefinition中的propertyValues，可以看到在propertyValuesList只有一个元素：属性b，name是b，value是一个RuntimeBeanReference对象，属性beanName为b。

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-19-00-49-image.png)

这是在什么时候保存的？答案是在beanDefinition解析阶段，有一个处理步骤是解析property子元素：parsePropertyElements(ele, bd)，在此方法中，比如解析xml中的a的属性b，会把property标签中的ref="b"保存为RuntimeBeanReference，源码如下：

```java
public void parsePropertyElement(Element ele, BeanDefinition bd) {
        String propertyName = ele.getAttribute(NAME_ATTRIBUTE);
        if (!StringUtils.hasLength(propertyName)) {
            error("Tag 'property' must have a 'name' attribute", ele);
            return;
        }
        this.parseState.push(new PropertyEntry(propertyName));
        try {
            if (bd.getPropertyValues().contains(propertyName)) {
                error("Multiple 'property' definitions for property '" + propertyName + "'", ele);
                return;
            }
            Object val = parsePropertyValue(ele, bd, propertyName);
            PropertyValue pv = new PropertyValue(propertyName, val);
            parseMetaElements(ele, pv);
            pv.setSource(extractSource(ele));
            bd.getPropertyValues().addPropertyValue(pv);
        }
        finally {
            this.parseState.pop();
        }
    }


public Object parsePropertyValue(Element ele, BeanDefinition bd, String propertyName) {
        String elementName = (propertyName != null) ?
                        "<property> element for property '" + propertyName + "'" :
                        "<constructor-arg> element";

        // Should only have one child element: ref, value, list, etc.
        NodeList nl = ele.getChildNodes();
        Element subElement = null;
        for (int i = 0; i < nl.getLength(); i++) {
            Node node = nl.item(i);
            if (node instanceof Element && !nodeNameEquals(node, DESCRIPTION_ELEMENT) &&
                    !nodeNameEquals(node, META_ELEMENT)) {
                // Child element is what we're looking for.
                if (subElement != null) {
                    error(elementName + " must not contain more than one sub-element", ele);
                }
                else {
                    subElement = (Element) node;
                }
            }
        }

        boolean hasRefAttribute = ele.hasAttribute(REF_ATTRIBUTE);
        boolean hasValueAttribute = ele.hasAttribute(VALUE_ATTRIBUTE);
        if ((hasRefAttribute && hasValueAttribute) ||
                ((hasRefAttribute || hasValueAttribute) && subElement != null)) {
            error(elementName +
                    " is only allowed to contain either 'ref' attribute OR 'value' attribute OR sub-element", ele);
        }

        /**
         * <bean id="a" class="test.A>
         *     <property> name="b" ref="b"/>
         * </property></bean>
         */
        if (hasRefAttribute) {
            // 获取到refName，比如是B
            String refName = ele.getAttribute(REF_ATTRIBUTE);
            if (!StringUtils.hasText(refName)) {
                error(elementName + " contains empty 'ref' attribute", ele);
            }
            // 把refName封装成RuntimeBeanReference对象
            RuntimeBeanReference ref = new RuntimeBeanReference(refName);
            ref.setSource(extractSource(ele));
            return ref;
        }
        else if (hasValueAttribute) {
            TypedStringValue valueHolder = new TypedStringValue(ele.getAttribute(VALUE_ATTRIBUTE));
            valueHolder.setSource(extractSource(ele));
            return valueHolder;
        }
        else if (subElement != null) {
            return parsePropertySubElement(subElement, bd);
        }
        else {
            // Neither child element nor "ref" or "value" attribute found.
            error(elementName + " must specify a ref or value", ele);
            return null;
        }
    }
```

然后一路跟进populateBean方法，F7进入方法：

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-19-20-34-image.png)

看到autowireMode的值是0，不会走这个if分支：

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-19-30-41-image.png)

重点是applyPropertyValues方法，按F7进入，来到resolveValueIfNecessary方法。

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-19-38-45-image.png)

进入valueResolver的resolveValueIfNecessary方法，来到第一个分支，进入resolveReference方法，发现依赖bean（此处是b）是在这里创建的，熟悉的beanFactory.getBean()方法。

```java
public Object resolveValueIfNecessary(Object argName, Object value) {
        // We must check each value to see whether it requires a runtime reference
        // to another bean to be resolved.
        if (value instanceof RuntimeBeanReference) {
            RuntimeBeanReference ref = (RuntimeBeanReference) value;
            return resolveReference(argName, ref);
        }
        else if (value instanceof RuntimeBeanNameReference) {
            String refName = ((RuntimeBeanNameReference) value).getBeanName();
            refName = String.valueOf(doEvaluate(refName));
            if (!this.beanFactory.containsBean(refName)) {
                throw new BeanDefinitionStoreException(
                        "Invalid bean name '" + refName + "' in bean reference for " + argName);
            }
            return refName;
        }
// 省略
}

// 创建bean
private Object resolveReference(Object argName, RuntimeBeanReference ref) {
        try {
            String refName = ref.getBeanName();
            refName = String.valueOf(doEvaluate(refName));
            if (ref.isToParent()) {
                if (this.beanFactory.getParentBeanFactory() == null) {
                    throw new BeanCreationException(
                            this.beanDefinition.getResourceDescription(), this.beanName,
                            "Can't resolve reference to bean '" + refName +
                            "' in parent factory: no parent factory available");
                }
                return this.beanFactory.getParentBeanFactory().getBean(refName);
            }
            else {
                /**
                 * populateBean时发现有依赖bean，则创建依赖bean
                 */
                Object bean = this.beanFactory.getBean(refName);
                this.beanFactory.registerDependentBean(refName, this.beanName);
                return bean;
            }
        }
        catch (BeansException ex) {
            throw new BeanCreationException(
                    this.beanDefinition.getResourceDescription(), this.beanName,
                    "Cannot resolve reference to bean '" + ref.getBeanName() + "' while setting " + argName, ex);
        }
    }
```

创建b，又会重新进入getBean, doGetBean, createBean, doCreateBean

同样的，创建b时发现bd中propertyValues存放的a的value也是RuntimeBeanReference类型。

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-20-55-20-image.png)

创建完成之后，a中有b，b中有a，循环往复：

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-21-16-36-image.png)

一直按F8之后，回到这里：

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-21-22-39-image.png)

因为以上所有的操作，都是这个循环开始处理beanName为a的情况，处理完之后回到这里，开始处理beanName为b的情况。

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-21-24-45-image.png)

完成之后，可以看到缓存的情况：

![](/Users/huxiangming/Library/Application%20Support/marktext/images/2022-05-02-21-29-09-image.png)

### 36，mybatis调试sql

```java
// 一路F7，进入CachingExecutor类
public <E> List<E> query(MappedStatement ms, Object parameterObject, RowBounds rowBounds, ResultHandler resultHandler) throws SQLException {
  BoundSql boundSql = ms.getBoundSql(parameterObject);
  CacheKey key = createCacheKey(ms, parameterObject, rowBounds, boundSql);
  return query(ms, parameterObject, rowBounds, resultHandler, key, boundSql);
}
// MappedStatement类
public BoundSql getBoundSql(Object parameterObject) {
  BoundSql boundSql = sqlSource.getBoundSql(parameterObject);
  List<ParameterMapping> parameterMappings = boundSql.getParameterMappings();
  if (parameterMappings == null || parameterMappings.size() <= 0) {
    boundSql = new BoundSql(configuration, boundSql.getSql(), parameterMap.getParameterMappings(), parameterObject);
  }

  // check for nested result maps in parameter mappings (issue #30)
  for (ParameterMapping pm : boundSql.getParameterMappings()) {
    String rmId = pm.getResultMapId();
    if (rmId != null) {
      ResultMap rm = configuration.getResultMap(rmId);
      if (rm != null) {
        hasNestedResultMaps |= rm.hasNestedResultMaps();
      }
    }
  }

  return boundSql;
}

// 进入getBoundSql方法，来到DynamicSqlSource类
public BoundSql getBoundSql(Object parameterObject) {
  DynamicContext context = new DynamicContext(configuration, parameterObject);
  rootSqlNode.apply(context);
  SqlSourceBuilder sqlSourceParser = new SqlSourceBuilder(configuration);
  Class<?> parameterType = parameterObject == null ? Object.class : parameterObject.getClass();
  SqlSource sqlSource = sqlSourceParser.parse(context.getSql(), parameterType, context.getBindings());
  BoundSql boundSql = sqlSource.getBoundSql(parameterObject);
  for (Map.Entry<String, Object> entry : context.getBindings().entrySet()) {
    boundSql.setAdditionalParameter(entry.getKey(), entry.getValue());
  }
  return boundSql;
}
```

![](D:\abc\giteeCode\java-note\MixedSqlSource.png)

![](D:\abc\giteeCode\java-note\2022-05-07-15-57-50-image.png)

```java
// 进入rootSqlNode.apply方法,来到MixedSqlNode
public class MixedSqlNode implements SqlNode {
  private List<SqlNode> contents;

  public MixedSqlNode(List<SqlNode> contents) {
    this.contents = contents;
  }

  public boolean apply(DynamicContext context) {
    for (SqlNode sqlNode : contents) {
      sqlNode.apply(context);
    }
    return true;
  }
}

// 进入apply方法，来到TextSqlNode类
public boolean apply(DynamicContext context) {
  GenericTokenParser parser = createParser(new BindingTokenParser(context));
  context.appendSql(parser.parse(text));
  return true;
}

private GenericTokenParser createParser(TokenHandler handler) {
  return new GenericTokenParser("${", "}", handler);
}

// 进入apply方法，来到StaticTextSqlNode类
public class StaticTextSqlNode implements SqlNode {
  private String text;

  public StaticTextSqlNode(String text) {
    this.text = text;
  }

  public boolean apply(DynamicContext context) {
    context.appendSql(text);
    return true;
  }

}
```