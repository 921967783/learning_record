#!/bin/bash

warnText="请重试"
echo ${warnText}

tail -f /usr/local/tomcat-list/tomcat8081/logs/catalina.out | grep --line-buffered ${warnText} |awk '{print $6; fflush()}'| while read ${warnText} ; do ps -ef|grep tomcat8081|grep -v grep|grep -v tail|awk '{ print $2}'|xargs kill -9 && echo "捕捉到错误关键字，开始重启" && nohup /usr/local/tomcat-list/tomcat8081/bin/startup.sh >/usr/local/tomcat-list/tomcat8081/logs/1.log \& && sleep 10m; done
