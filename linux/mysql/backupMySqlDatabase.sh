#!/bin/bash
#Shell Command For Backup MySQL Database Everyday Automatically By Crontab
#Time 2018-7-13
#Name Michael Wu

MYSQLHOST=10.16x.xx.xx
PORT=3306
USER=root
PASSWORD=xxxxx
DATABASE1=db1
DATABASE2=db2
DATABASE3=db3
DATABASE4=mysql
BACKUP_DIR=/apps/data/backup/database/                #备份数据库文件的路径
LOGFILE=/apps/data/backup/database/data_backup.log    #备份数据库脚本的日志文件
DATE=`date +%Y%m%d-%H-%M -d -121minute`               #获取当前系统时间-121分钟，计划在凌晨两点执行备份
DUMPFILE1=$DATABASE1-$DATE.sql                        #需要备份的数据库名称
DUMPFILE2=$DATABASE2-$DATE.sql
DUMPFILE3=$DATABASE3-$DATE.sql
DUMPFILE4=$DATABASE4-$DATE.sql
ARCHIVE1=$DUMPFILE1-tar.gz                            #备份的数据库压缩后的名称
ARCHIVE2=$DUMPFILE2-tar.gz
ARCHIVE3=$DUMPFILE3-tar.gz
ARCHIVE4=$DUMPFILE4-tar.gz

if [ ! -d $BACKUP_DIR ];                              #判断备份路径是否存在，若不存在则创建该路径
then
mkdir -p "$BACKUP_DIR"
fi

echo -e "\n" >> $LOGFILE
echo "------------------------------------" >> $LOGFILE
echo "BACKUP DATE:$DATE">> $LOGFILE
echo "------------------------------------" >> $LOGFILE

cd $BACKUP_DIR                           #跳到备份路径下
mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 -B $DATABASE1 > $DUMPFILE1    #使用mysqldump备份数据库
if [[ $? == 0 ]]; then
tar czvf $ARCHIVE1 $DUMPFILE1 >> $LOGFILE 2>&1                               #判断是否备份成功，若备份成功，则压缩备份数据库，否则将错误日志写入日志文件中去。
echo "$ARCHIVE1 BACKUP SUCCESSFUL!" >> $LOGFILE
rm -f $DUMPFILE1
else
echo “$ARCHIVE1 Backup Fail!” >> $LOGFILE
fi

mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 -B $DATABASE2 > $DUMPFILE2
if [[ $? == 0 ]]; then
tar czvf $ARCHIVE2 $DUMPFILE2 >> $LOGFILE 2>&1
echo "$ARCHIVE2 BACKUP SUCCESSFUL!" >> $LOGFILE
rm -f $DUMPFILE2
else
echo “$ARCHIVE2 Backup Fail!” >> $LOGFILE
fi

mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 -B $DATABASE3 > $DUMPFILE3
if [[ $? == 0 ]]; then
tar czvf $ARCHIVE3 $DUMPFILE3 >> $LOGFILE 2>&1
echo "$ARCHIVE3 BACKUP SUCCESSFUL!" >> $LOGFILE
rm -f $DUMPFILE3
else
echo “$ARCHIVE3 Backup Fail!” >> $LOGFILE
fi

mysqldump -h $MYSQLHOST -P $PORT  -u$USER -p$PASSWORD --single-transaction --master-data=2 --events --ignore-table=mysql.events -B $DATABASE4 > $DUMPFILE4
if [[ $? == 0 ]]; then
tar czvf $ARCHIVE4 $DUMPFILE4 >> $LOGFILE 2>&1
echo "$ARCHIVE4 BACKUP SUCCESSFUL!" >> $LOGFILE
rm -f $DUMPFILE4
else
echo “$ARCHIVE4 Backup Fail!” >> $LOGFILE
fi
