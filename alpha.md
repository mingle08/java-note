1，安装oh-my-zsh
```
sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
```

2，编译spring源码（注意，gradlew后面的空格不能少）
```
./gradlew :spring-oxm:compileTestJava
```

3，github代码下载
```
git clone git@github.com:mingle08/algorithm.git
git clone git@github.com:mingle08/jdk8SourceNote.git
git clone git@github.com:mingle08/mybatis-3-study.git
```

4，gitee代码下载
```
git clone git@gitee.com:mingle08/java-note.git
```

5，快捷键
* idea
  |MAC|名称|WINDOWS|
  |:-|:-:|:-|
  |command + N|自动生成get/set方法|Alt + Enter|
  |command + option + O|优化import|Ctrl + Alt + O|
  |control + H|查看继承关系|Ctrl + H|
  |option + command + L|格式化代码|Ctrl + Alt +L|
  |command + O|查找类文件|Ctrl + N|
  |command + L|跳转到行号|Ctrl + G|
  |option + space| 查看光标处的方法、类的定义|/|
  |command + shift + F|全局查找|Ctrl + Shift + F|

* visual studio code
  调出终端/隐藏终端    control + 反引号（esc键下面）

* 浏览器
  光标定位在地址栏    command + L

* 微信截图
  control + command + A
