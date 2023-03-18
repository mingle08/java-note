# DB2

## 工作中用到的数据库，银行系统

### 1 reorg

#### 1.1 什么时候需要reorg操作

* 在DB2数据库中，修改完表的结构时，是否需要对表做一个reorg操作才能使表的状态恢复正常？

* 有以下4种操作，需要对表做reorg操作

* SET DATA TYPE altered-data-type

  但有以下两种情况是例外，不需要reorg：
  * 1). Increasing the length of a VARCHAR or VARGRAPHIC column
  * 2). Decreasing the length of a VARCHAR or VARGRAPHIC column without truncating trailing blanks from existing data
* SET NOT NULL
* DROP NOT NULL
* DROP COLUMN

其他的操作，理论上都不需要REORG，但有些操作，是需要REORG之后才能实际生效的，比如"ALTER TABLE ... COMPRESS YES"，语法上不需要REORG操作，也不会影响表的增删改查操作，但只有REORG之后，才能真正开启压缩：
After a table has been altered to enable row compression, all rows in the table can be compressed immediately by performing one of the following actions:
        1. REORG command
        2. Online table move
        3. Data unload and reload

<https://www.bbsmax.com/A/QV5ZvKen5y/>

#### 1.2 reorg不是sql

```sql
REORG TABLE d3finst.TA_PAY_HIST
```

不能在数据库里直接执行，正确的是以下命令：

```text
call sysproc.admin_cmd('REORG TABLE d3finst.TA_PAY_HIST')
```
