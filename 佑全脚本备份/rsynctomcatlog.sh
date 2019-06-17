#!/bin/bash
freetemple=`df -h|grep '/dev/vda1'|awk '{print $4}'|awk -F 'G' '{print $1}'`
echo $freetemple
mixtemple=30
echo $mixtemple

if [ `echo "$freetemple <= $mixtemple"|bc` -eq 1 ]
then
echo 'no free template'
#rsync -avz /usr/local/tomcat8081/logs/catalina.out root@172.16.119.117:/usr/local/src/116tomcatlog/catalina8081_$(date +%Y%m%d).out
#rsync -avz /usr/local/tomcat8082/logs/catalina.out root@172.16.119.117:/usr/local/src/116tomcatlog/catalina8082_$(date +%Y%m%d).out
echo '' > /usr/local/tomcat8081/logs/catalina.out
echo '' > /usr/local/tomcat8082/logs/catalina.out
/usr/local/python3/bin/python3 /tmp/cpuget/cpuinfo.py error
fi

