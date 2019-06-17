clear
cd $HOME/SmartESB/bin;
pid0=`ps -ef|grep java|grep CONSOLE|awk -F " " '{print $2}'`
kill -9 $pid0
pid1=`ps -ef|grep java|grep "IN"|awk -F " " '{print $2}'`
kill -9 $pid1
pid2=`ps -ef|grep java|grep JOURNAL|awk -F " " '{print $2}'`
kill -9 $pid2
pid3=`ps -ef|grep java|grep FLOW | awk -F " " '{print $2}'`
kill -9 $pid3
pid4=`ps -ef|grep java|grep SmartMOM | awk -F " " '{print $2}'`
kill -9 $pid4
rm -f out.smart;

sleep 3
num0=`ps -ef | grep java |  grep "SmartMOM" | wc -l |awk '{print $1}'`
num1=`ps -ef | grep java |  grep "CONSOLE" | wc -l |awk '{print $1}'`
num2=`ps -ef | grep java |  grep "IN OUT ROUTER" | wc -l |awk '{print $1}'`
num3=`ps -ef | grep java |  grep "JOURNAL" | wc -l|awk '{print $1}'`
num4=`ps -ef | grep java |  grep "FLOW" | wc -l|awk '{print $1}'`
num5=`expr $num0+$num1`
num5=`expr $num5+$num2`
num5=`expr $num5+$num3`
num5=`expr $num5+$num4`
if [ $num5 -gt 0 ]
then
 echo "尚有进程未关闭,请检查...[$num5]"
 echo "未关闭进程数量:"
 echo "startmom=[$num0], console=$num1,in out router=$num2,journal=$num3,flow=$num4"
 return $num5 
 exit;
fi
echo "关闭进程成功"
