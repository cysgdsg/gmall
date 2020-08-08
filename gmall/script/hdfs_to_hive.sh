#!/bin/bash

hive=/u01/hive/apache-hive-2.3.3-bin/bin/hive
if [ -n $1 ] ;then
 dt_now=$1
else
 dt_now=`date -d "-1 day" +%F`
fi

cp /u01/warehouse/conf/hdfs_to_hive.cnf /u01/warehouse/hdfs_to_hive.cnf

#判断是否要循环
count_line=`cat /u01/warehouse/hdfs_to_hive.cnf | grep wait | wc -l`
echo $count_line

while [ $count_line -ge 1 ];
do

#读取循环的表名
line_data=$(cat /u01/warehouse/hdfs_to_hive.cnf | grep wait | head -1)
table_name=$(echo $line_data | gawk -F$ '{print $1}')
hive_name=$(echo $line_data | gawk -F$ '{print $2}')

$hive -e "load data inpath '/user/mysql/$table_name/$dt_now' overwrite into table gmall.${hive_name} partition (dt='$dt_now')"

if [ $? = 0 ] ;then
   echo  "${hive_name} execute success"  
   sed -i "/${table_name}/s/wait/success/g"  /u01/warehouse/hdfs_to_hive.cnf 
else
   echo  "${hive_name}execute false"  
   sed -i "/${table_name}/s/wait/false:/g"  /u01/warehouse/hdfs_to_hive.cnf 
fi                                
count_line=`cat /u01/warehouse/hdfs_to_hive.cnf | grep wait | wc -l`
echo  "${count_line} table will be execate"

done

echo "execute success"