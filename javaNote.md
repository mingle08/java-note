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

​	a. 对CPU资源敏感（会和服务抢资源）

​	b. 无法处理浮动垃圾，有可能出现“Concurrent Mode Failure"失败进而导致另一次完全"stop the world"的Full GC的产生，临时启用Serial Old收集器来重新进行老年代的垃圾收集，但这样停顿时间就很长了

​	c. 大量空间碎片的产生

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

// 进一步查看TransactionDefinition	
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

// 隔离级别，是用Connection接口中的常量赋值的，我们来看一下Connection类，这是java.sql包中的：Connection接口
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

（1）Redis中的实现

​	Server.h类中的zskiplist

（2）JDK中的实现

​	ConcurrentSkipListMap.java

### 19，dubbo的整体架构设计和分层
（1）5个角色<br>
    注册中心registry：服务注册与发现<br>
    服务提供者provider：暴露服务<br>
    服务消费者consumer：调用远程服务<br>
    监控中心monitor：统计服务的调用次数和调用时间<br>
    窗口container：服务允许窗口<br>
（2）调用流程<br>
    1: container容器负责启动、加载、运行provider<br>
    2：provider在启动时，向registry中心注册自己提供的服务<br>
    3：consumer在启动时，向registry中心订阅自己所需的服务<br>
    4：registry返回服务提供者列表给consumer，如果有变更，registry将基于长连接发送变更给consumer<br>
    5：consumer调用provider服务，基于负载均衡算法进行调用<br>
    6：consumer调用provider的统计，基于短连接定时每分钟一次统计到monitor<br>
（3）分层<br>
    1：接口服务层（Service）：面向开发者、业务代码、接口、实现等<br>
    2：配置层（Config）：对外配置接口，以ServiceConfig与ReferenceConfig为中心<br>
    3：服务代理层（Proxy）：对生产者和消费者、dubbo都会产生一个代理类封装调用细节，业务层对调用细节无感<br>
    4：服务注册层（Registry）：封装服务地址的注册与发现，以服务URL为中心<br>
    5：路由层（Cluster）：封装多个提供者的路由和负载均衡，并桥接注册中心<br>
    6：监控层（Monitor）：RPC调用次数和调用时间监控<br>
    7：远程调用层（Protocal）：封装RPC调用<br>
    8：信息交换层（Exchange）：封装请求响应模式，同步转异步<br>
    9：网络传输层（Transport）：抽象mina和netty为统一接口，统一网络传输接口<br>
    10：数据序列化层（Serialize）：数据传输的序列化和反序列化<br>

### 20，ZAB协议与RAFT协议的区别
    （1）ZAB<br>
    Leader 一个zookeeper集群同一时刻仅能有一个Leader。Leader负责接收所有的客户端的请求。<br>
    Follower 提供读服务，参与选举。<br>
    Observer 仅提供读服务。<br>

    （2）Raft<br>
    Leader 负责接收所有的客户端的请求。<br>
    Follower 读写请求都转发到Leader，参与选举。<br>
    Candidate 每个节点上都有一个倒计时器 (Election Timeout)，时间随机在 150ms 到 300ms 之间。在一个节点倒计时结束 (Timeout) 后，这个节点的状态变成 Candidate 开始选举，它给其他几个节点发送选举请求 (RequestVote)。选举成功则变为Leader。<br>

### 21，缓存雪崩、缓存穿透、缓存击穿
    （1）缓存雪崩

    （2）缓存穿透

    （3）缓存击穿