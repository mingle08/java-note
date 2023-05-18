# Shell 脚本学习

## 1 特殊变量

### $?

### $#

### $!

### $_

### $$

### $*

### $@

## 2 基本语法

```
${变量}                    返回variable的值
${#变量}                   返回variable长度，字符长度
${变量:offset}             返回变量下标offset数值之后的字符（下标从0开始)
${变量:offset:length}      返回变量下标offset之后的length限制的字符（下标从0开始)
${变量#word}               从变量开头，删除最短匹配的word子串
${变量##word}              从变量开头，删除最长匹配的word子串
${变量%word}               从变量结尾，删除最短的word子串
${变量%%word}              从变量结尾，删除最长匹配的word子串
${变量/pattern/string}     用string代替第一个匹配的pattern
${变量//pattern/string}    用string代替所有的pattern
```

## 3 变量的扩展

### 3.1 语法

```plaintext
result=${parameter:-word}
如果parameter为空，返回word字符串，赋值给result

result=${parameter:=word}
如果parameter为空，则parameter的值为word，result为word

result=${parameter:?word}
如果parameter为空，word当作stderr输出，否则输出变量值。用于变量为空导致错误时，返回错误信息

result=${parameter:+word}
如果parameter为空，什么都不做，否则返回word给result
```

### 3.2 实际应用

```plaintext
find xargs 搜索，且删除
# 删除7天以上的过期数据
find 需要搜索的目录 -name 你要搜索的文件名字 -type 文件类型 -mtime +7|xargs rm -f

# 如果有bug歧义，就会在当前目录，搜索，删除
# find ${dir_path} -name '*.tar.gz' -type f - mtime +7|xargs rm -f

# 变量扩展的改进

find ${dir_path:=/data/mysql_bak_data/} -name '*.tar.gz' -type f -mtime +7|xargs rm -f
```

## 4 内置命令、外置命令

### 4.1 概念

* 内置命令：在系统启动时就加载到内存，常驻内存，执行效率更高，但占用资源
* 用户需要从硬盘中读取程序文件，再读入内存加载

### 4.2 特点

* 内置命令：不会产生子进程；已经和shell编译成一体，作为shell的组成部分
* 外部命令：一定会产生子进程，系统开销高

## 5 shell特殊符号的处理

```plaintext
${vars}    取出变量结果
$()        在括号中执行命令，且拿到命令的执行结果
``         在括号中执行命令，且拿到命令的执行结果
()         开启子shell，执行命令
$vars      取出变量结果
```

## 6 数值计算

### 6.1 双小括号(())

* 只能用于整数运算

### 6.2 特殊符号

* ++
* --

### 6.3 let命令运算

* 效果等同于双小括号，但效率比双小括号低

### 6.4 expr命令

* 不是很好用，基于空格传入参数，对于乘号要转入

  ```plaintext
  expr 5 \* 3
  ```
* 支持模式匹配

  * 冒号:  计算字符串的字符数量
  * .*  任意的字符串重复0次或多次
    ```plaintext
    expr Chandler.png ":" ".*"
    ```

### 6.5 bc计算

* 可进行小数运算

### 6.6 中括号计算

### 7 逻辑判断符号

```plaintext
&&    -a     与运算，两边都为真，结果才为真
||    -o     或运算，两边有一个为真，结果就为真
```

| 在 [ ] 和 test 中使用的操作符 | 在 [[ ]] 和 (( )) 中使用的操作符 | 说明 |
| :---------------------------: | :------------------------------: | ---- |
|              -a              |                &&                | and  |
|              -o              |               \|\|               | or   |
|               !               |                !                | not  |

### 8 三剑客-grep

### 9 三剑客-sed

### 10 三剑客-awk

* 一种编程语言，类似C语言

#### 10.1 特点与应用场景

* 用于过滤，统计，计算
* 适用于过滤，统计日志

#### 10.2 执行过程

```shell
# column t是美化输出结果，对齐
awk -F "," 'BEGIN{print "name"}NR==2{print $2}END{print "end of file"}' oldboy.txt | column t
```

* BEGIN
* READING
* END
* filename

#### 10.3 行与列

| 名词                                | awk的叫法     | 说明                 |
| ----------------------------------- | ------------- | -------------------- |
| 行                                  | 记录record    | 每一行默认用回车分割 |
| 列                                  | 字段，域field | 每一列默认用空格分割 |
| awk中行和列的结束标记都是可以修改的 |               |                      |

* | awk              | 一种编程语言    | 类似C语言        |
  | ---------------- | --------------- | ---------------- |
  | NR == 1          | 取出第一行      | number of record |
  | NR >= 1&&NR <= 5 | 取出1到5行范围  |                  |
  | 符号             | > < >= <= == != |                  |
  | 模式匹配         | /oldboy/        |                  |
  | 范围匹配         | /105/, /108/    |                  |
  | NF               | 每一行有多少列  | $NF表示最后一列  |
* 取列
  * -F 指定分隔符：指定每一列的结束标记（默认是空格、连续的空格、tab键)
  * $数字  取出某一列
  * $NF  表示最后一列

### 11 括号的使用

#### 11.1 小括号()

* 单括号 ( command )                 子shell执行命令
* 双括号 (( digit expression ))      高级数学表达式

#### 11.2 中括号[]

* 单括号 [ condition ]                  与test命令等效

  * 数值比较
  * 字符串比较
  * 文件比较
* 双括号 [[ string expression ]]    字符串比较的高级特性

### 12 退出状态码

* 对于成功结束的命令，其退出状态码是0.
* 对于因错误而结束的命令，其退出状态码是一个正整数

### 13 shell中的if-then语句

* 如果if后面的命令的退出状态码为0，那么位于then部分的命令就会被执行。
* 如果该命令的退出状态码是其他值，则then部分的命令不会被执行。
