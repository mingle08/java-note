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

### 3.2 实际应用 {扩展的语法}

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
