# jdk文档之三

## 序号（61~90）

### 61 LocalDate类的toEpochDay()方法

* 方法源码

```java
    public long toEpochDay() {
        long y = year;
        long m = month;
        long total = 0;
        total += 365 * y;
        if (y >= 0) {
            total += (y + 3) / 4 - (y + 99) / 100 + (y + 399) / 400;
        } else {
            total -= y / -4 - y / -100 + y / -400;
        }
        total += ((367 * m - 362) / 12);
        total += day - 1;
        if (m > 2) {
            total--;
            if (isLeapYear() == false) {
                total--;
            }
        }
        return total - DAYS_0000_TO_1970;
    }
```
* m月份距离1月份的天数
    为什么是(367 * m - 362) / 12 ?
  * 运行这句代码
    ```java
    public static void main(String[] args) {
        int days = 0;
        for (int m = 1; m <= 12; m++) {
            days = (367 * m - 362) / 12;
            System.out.println("m=" + m + ",days=" + days);
        }
    }
    /**
     * 
        m=1,days=0
        m=2,days=31
        m=3,days=61
        m=4,days=92
        m=5,days=122
        m=6,days=153
        m=7,days=183
        m=8,days=214
        m=9,days=245
        m=10,days=275
        m=11,days=306
        m=12,days=336
     */
    ```
  * stackoverflow上的提问解答
     
    ```txt
    Combined with if (m > 2) and if (isLeapYear() == false), it's a way to get the number of days at the start of a month without a lookup table (with integer division).

    (1) Non-Leap Years
    m=1 (Jan): 0 (diff: 0) //days between (1.1, 1.1)
    m=2 (Feb): 31 (diff: 31) //days between (2.1, 1.1)
    m=3 (Mar): 59 (diff: 28) //days between (3.1, 2.1)
    m=4 (Apr): 90 (diff: 31) //days between (4.1, 3.1)
    m=5 (May): 120 (diff: 30) //days between (5.1, 4.1)
    m=6 (Jun): 151 (diff: 31) //days between (6.1, 5.1)
    m=7 (Jul): 181 (diff: 30) //days between (7.1, 6.1)
    m=8 (Aug): 212 (diff: 31) //days between (8.1, 7.1)
    m=9 (Sep): 243 (diff: 31) //days between (9.1, 8.1)
    m=10 (Oct): 273 (diff: 30) //days between (10.1, 9.1)
    m=11 (Nov): 304 (diff: 31) //days between (11.1, 10.1)
    m=12 (Dec): 334 (diff: 30) //days between (12.1, 11.1)

    (2) Leap Years
    m=1 (Jan): 0 (diff: 0) //days between (1.1, 1.1)
    m=2 (Feb): 31 (diff: 31) //days between (2.1, 1.1)
    m=3 (Mar): 60 (diff: 29) //days between (3.1, 2.1)
    m=4 (Apr): 91 (diff: 31) //days between (4.1, 3.1)
    m=5 (May): 121 (diff: 30) //days between (5.1, 4.1)
    m=6 (Jun): 152 (diff: 31) //days between (6.1, 5.1)
    m=7 (Jul): 182 (diff: 30) //days between (7.1, 6.1)
    m=8 (Aug): 213 (diff: 31) //days between (8.1, 7.1)
    m=9 (Sep): 244 (diff: 31) //days between (9.1, 8.1)
    m=10 (Oct): 274 (diff: 30) //days between (10.1, 9.1)
    m=11 (Nov): 305 (diff: 31) //days between (11.1, 10.1)
    m=12 (Dec): 335 (diff: 30) //days between (12.1, 11.1)
    ```

* 结论
    此公式计算的m代表的月份的1号与1月1号之间的天数。
    * 当m=1时，1月1号与1月1号之间间隔是0天；
    * 当m=2时，2月1号与1月1号之间的天数，其实就是1月的天数；
    * 当m=3时，3月1号与1月1号之间的天数，其实就是1月和2月的天数之和（61 = 31 + 30）。而2月份在非闰年是28天，在闰年是29天。公式中都按30天来计算，所以在之后有m > 2时减1天（闰年,29=30-1），非闰年(isLeapYear() == false)再减1天（30-1-1=28）
    * 336 - 1 = 335，对应闰年
    * 336 - 1 - 1 = 334，对应非闰年

### LocalDate类中的isLeapYear()方法

* 方法源码
  ```java
    @Override // override for Javadoc and performance
    public boolean isLeapYear() {
        return IsoChronology.INSTANCE.isLeapYear(year);
    }
  ```

* 真正的代码逻辑在IsoChronology类
  ```java
    @Override
    public boolean isLeapYear(long prolepticYear) {
        return ((prolepticYear & 3) == 0) && ((prolepticYear % 100) != 0 || (prolepticYear % 400) == 0);
    }
  ```
* 是否被4整除的写法
  ```java
    (prolepticYear & 3) == 0
  ```
  * 能被4整除的数字，其二进制表示的最后两位一定是00.
  * 十进制的3，二进制表示为0000 0011。
  * 如果prolepticYear的最后两位是00，那么prolepticYear & 3的结果一定也是0.

### 62 计算某月份有多少天
* 代码
  ```java
    public int calcDaysOfMonth(Integer month) {
      return  (month < 8) ^ (month % 2 == 0) ? 31:30-2*(month ==2) 
    }
  ```

* 代码解析
  ```java
    (month < 8) ^ (month % 2 == 0) ? 31:30-2*(month ==2) 
  ```
  * (month < 8) ^ (month % 2 == 0)
    * month < 8，当month为1、3、5、7时，结果为true
    * month % 2 == 0，当month为2、4、6、8、10、12时，结果为true
    * 1 ^ true = 0
    * 3 ^ true = 0
    * 5 ^ true = 0
    * 7 ^ true = 0
    * 2 ^ true = 1
    * 4 ^ true = 1
    * 6 ^ true = 1
    * 8 ^ true = 1
    * 10 ^ true = 1
    * 12 ^ true = 1

  * 30-2*(month ==2)
    * month == 2，当month为2时，结果为true
    * 30-2*true = 28
    * 30-2*false = 30

### 63 计算某天是星期几
* 代码
  ```java
    int dow(int y, int m, int d) {
        //int[] arr = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
        y -= m < 3;
    // return (y + y / 4 - y / 100 + y / 400 + arr[m - 1] + d) % 7;
    return (y + y / 4 - y / 100 + y / 400 + "-bed=pen+mad."[m] + d) % 7;
  }
  ```

### 64 找出数组中只出现一次的数
Given an array of integers, every element appears three times except for one. Find that single one.

public int singleNumber(int[] A) {
    int ones = 0, twos = 0;
    for(int i = 0; i < A.length; i++){
        ones = (ones ^ A[i]) & ~twos;
        twos = (twos ^ A[i]) & ~ones;
    }
    return ones;
}

### 65 Long中的lowestOneBit方法
* 代码
  ```java
    public static int lowestOneBit(long i) {
        return (int)(i & -i);
    }
  ```

* 代码解析
  ```java
    i & -i
  ```
  * -i
    * i的二进制表示
      ```java
        0000 0000 0000 0000 0000 0000 0000 0101
      ```
    * 取反
      ```java
        1111 1111 1111 1111 1111 1111 1111 1010
      ```
    * 加1
      ```java
        1111 1111 1111 1111 1111 1111 1111 1011
      ```
  * i & -i
      ```java
        0000 0000 0000 0000 0000 0000 0000 0101
      ```
      ```java
        1111 1111 1111 1111 1111 1111 1111 1011
      ```
      ```java
        0000 0000 0000 0000 0000 0000 0000 0001
      ```
  * 这个方法是求：最右边的1，代表的十进制数值是多少。

### 66 HashMap的get方法与containsKey方法
* 代码
  ```java
    public V get(Object key) {
        Node<K,V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
    }

    public boolean containsKey(Object key) {
        return getNode(hash(key), key) != null;
    }
  ```
