#! /bin/bash

warehouse=/u01/warehouse
log=/u01/warehouse/log/
if [ -n $1 ] ;then
   dt=$1   
else
   dt=`date -d "-1 day" +%F`
fi

cp /u01/warehouse/conf/mysql_to_hdfs.cnf /u01/warehouse/mysql_to_hdfs.cnf

#判断是否要循环
count_line=`cat /u01/warehouse/mysql_to_hdfs.cnf | grep wait | wc -l`
echo $count_line

while [ $count_line -ge 1 ];
do

#读取循环的表名
line_data=$(cat $warehouse/mysql_to_hdfs.cnf | grep wait | head -1)
table_name=$(echo $line_data | gawk -F$ '{print $1}')

/u01/sqoop/bin/sqoop import \
--connect jdbc:mysql://192.168.179.128:3306/gmall \
--username root \
--password Cy_123456 \
--target-dir /user/mysql/$table_name/$dt \
--delete-target-dir \
--query "select * from $table_name where id>1 and \$CONDITIONS" \
--num-mappers 1 \
--fields-terminated-by '\t' \
--null-string '\\N' \
--null-non-string '\\N' > /u01/warehouse/log/${dt}.log

if [ $? = 0 ] ;then
   echo  "${table_name} execute success"  
   sed -i "/${table_name}/s/wait/success/g"  /u01/warehouse/mysql_to_hdfs.cnf 
else
   echo  "${table_name}execute false"  
   sed -i "/${table_name}/s/wait/false:/g"  /u01/warehouse/mysql_to_hdfs.cnf 
fi                                
count_line=`cat /u01/warehouse/mysql_to_hdfs.cnf | grep wait | wc -l`
echo  "${count_line} table will be execate"

done

echo "execute success"