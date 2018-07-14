# backupMySqlDatabase.sh MySQL数据库备份脚本
> 此备份脚本使用`mysqldump`命令实现备份，使用到的部分参数说明如下：
```
--single-transaction 
  能保证innodb引擎的备份数据是一致性；myisam引擎需要使用--lock-all-tables参数；
--master-data=2
  表示在dump过程中记录主库的binlog和pos点，并在dump文件中注释掉这一行；
```
