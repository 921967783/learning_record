#!/bin/bash
#方法1
find /usr/local/tomcat-list/tomcat8101/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8101/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8102/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8102/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8103/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8103/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8104/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8104/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8105/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8105/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8106/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8106/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8107/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8107/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8108/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8108/logs/catalina.out
sleep 1s
find /usr/local/tomcat-list/tomcat8109/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcat-list/tomcat8109/logs/catalina.out
sleep 1s
find /usr/local/tomcatAI/logs/ -mtime +7 -name "*201?*"|xargs rm -rf
echo ' '>/usr/local/tomcatAI/logs/catalina.out
sleep 1s


#/bin/bash
#方法2
tomcat_list=(tomcat8101 tomcat8102 tomcat8103 tomcat8104 tomcat8105 tomcat8106 tomcat8107 tomcat8108)
base_url1='/usr/local/tomcat-list/'
base_url2='/log/'
for i in $(seq 0 7);
do
#echo $base_url1${tomcat_list[i]}$base_url2;
a[i]=$base_url1${tomcat_list[i]}$base_url2;
done

for i in $(seq 0 7);
do
#mkdir -p ${a[i]}
echo `find ${a[i]} -mtime -7 -name "*201?*"`
find ${a[i]} -mtime -7 -name "*201?*"|xargs rm -rf >>/root/rm.log
#echo "rm ${a[i]}"
done
