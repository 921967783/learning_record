clear
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "开始启动进程........."

#判断smartmom进程是否启动
cd $HOME/SmartMOM
./startMom.sh;
i=0
while [ $i -eq 0 ]
do
num0=`ps -ef | grep java |  grep "SmartMOM" | wc -l |awk '{print $1}'`
if [ $num0 -eq 1 ]
then
i=1
else
echo "间隔5秒判断num=$num0"
sleep 5
fi
done


cd $HOME/SmartESB/bin;
#判断console启动
./1-startConsole.sh;
i=0
while [ $i -eq 0 ]
do
num0=`grep "Server startup in" console.log | wc -l |awk '{print $1}'`
if [ $num0 -eq 1 ]
then
i=1
else
echo "间隔5秒判断num=$num0"
sleep 5
fi
done


#脚本2启动
echo "start 2-startSmart.sh"
./2-startSmart.sh;
i=0
while [ $i -eq 0 ]
do
num0=`grep "<ROUTER>" out.smart | wc -l |awk '{print $1}'`
num1=`grep "<OUT>" out.smart | wc -l |awk '{print $1}'`
num2=`grep "<IN>" out.smart | wc -l |awk '{print $1}'`
num3=`expr $num0+$num1+$num2`
echo $num3
if [ $num3 -eq 3 ]
then
i=1
else
echo "间隔十秒判断num=$num3"
sleep 10
fi
done

#判断JOURNAL进程
./3-startJournal.sh;
i=0
while [ $i -eq 0 ]
do
num0=`grep "<JOURNAL>" journal.log | wc -l |awk '{print $1}'`
if [ $num0 -eq 1 ]
then
i=1
else
echo "间隔5秒判断num=$num0"
sleep 5
fi
done

#判断FLOW进程
./4-startFlow.sh;
i=0
while [ $i -eq 0 ]
do
num0=`grep "<FLOW>" flow.log | wc -l |awk '{print $1}'`
if [ $num0 -eq 1 ]
then
i=1
else
echo "间隔5秒判断num=$num0"
sleep 5
fi
done
echo "应用进程启动完成!!!!!"
echo "                                                  "
echo "                                                  "
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "检查进程与协议........."
num0=`ps -ef | grep java |  grep "SmartMOM" | wc -l |awk '{print $1}'`
num1=`ps -ef | grep java |  grep "CONSOLE" | wc -l |awk '{print $1}'`
num2=`ps -ef | grep java |  grep "IN OUT ROUTER" | wc -l |awk '{print $1}'`
num3=`ps -ef | grep java |  grep "JOURNAL" | wc -l|awk '{print $1}'`
num4=`ps -ef | grep java |  grep "FLOW" | wc -l|awk '{print $1}'`
if [ $num0 -ne 1 ]
then
 echo "SmartMOM进程未启动成功，请检查!!!!!!!!!!!!"
 exit;
elif [ $num1 -ne 1 ]
then
 echo "CONSOLE进程未启动成功，请检查!!!!!!!!!!!!"
 exit;
elif [ $num2 -ne 1 ]
then
 echo "IN OUT ROUTER进程未启动成功，请检查!!!!!!!!!!!!"
 exit;
elif [ $num3 -ne 1 ]
then
 echo "JOURNAL进程未启动成功，请检查!!!!!!!!!!!!"
 exit;
elif [ $num4 -ne 1 ]
then
 echo "FLOW进程未启动成功，请检查!!!!!!!!!!!!"
 exit;
fi

echo "进程SmartMOM、COLSOLE、IN OUT ROUTER、JOURNAL、FLOW启动无误"
cd $HOME/SmartESB/configs/out_conf/protocol/autobak/configurations;
num0=`ls -ltr *.xml | wc -l | awk '{print $1}'`
if [ $num0 -gt 50 ]
then
echo "接出方协议生成成功....[$num0]"
else
echo "接出方协议生成失败....[$num0]"
fi
cd $HOME/SmartESB/configs/in_conf/protocol/autobak/configurations;
num0=`ls -ltr *.xml | wc -l| awk '{print $1}'`
if [ $num0 -gt 16 ]
then
echo "接入方协议生成成功....[$num0]"
else
echo "接入方协议生成失败....[$num0]"
fi
echo "进程与协议检查通过!!!!!!"
echo "                                                  "
echo "                                                  "
echo "=================================================="
