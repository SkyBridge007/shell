# backupMySqlDatabase.sh --MySQL数据库备份脚本
> 此备份脚本使用`mysqldump`命令实现备份，使用到的部分参数说明如下：
```
--single-transaction 
  能保证innodb引擎的备份数据是一致性；myisam引擎需要使用--lock-all-tables参数；
--master-data=2
  表示在dump过程中记录主库的binlog和pos点，并在dump文件中注释掉这一行；
```
## 不记录GTID备份数据
```
mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 --set-gtid-purged=OFF -B $DATABASE > $DUMPFILE
```
## 备份mysql数据库
mysqldump命令默认不备份mysql event记录，`--events --ignore-table=mysql.events`参数可消除备份时产生的警告信息
```
mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 --events --ignore-table=mysql.events -B  $DATABASE > $DUMPFILE
```
## 备份所有数据
```
mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 --events --ignore-table=mysql.events --all-databases > $DUMPFILE
```

## 配置Linux定时任务
```
# 进入定时任务编辑状态
[root@mvxl6437 ~]# crontab -e

1 1 1 * * logrotate -f /etc/logrotate.d/midea_audit.log
00 02 * * * root /usr/local/bin/backupMySqlDatabase             #定义每天凌晨2点00分执行备份数据库脚本

# 编辑完成后保存退出，使用crontab -l查看生效的定时任务
[root@mvxl6437 ~]# crontab -l
1 1 1 * * logrotate -f /etc/logrotate.d/midea_audit.log
00 02 * * * root /usr/local/bin/backupMySqlDatabase             #定义每天凌晨2点00分执行备份数据库脚本 
[root@mvxl6437 ~]# 

# 一起来看看crontab的说明：
[root@mvxl6437 ~]# cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root
HOME=/

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
  00 02 * * * root /usr/local/bin/backupMySqlDatabase             #定义每天凌晨2点00分执行备份数据库脚本
```
