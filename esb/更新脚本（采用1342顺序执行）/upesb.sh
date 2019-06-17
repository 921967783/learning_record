#cdate=`date "+%Y%m%d"`
cdate=`date "+%Y%m%d%H%M"`
UpdateDir=$HOME/SmartESB/bin/ESBupdate
updfile=$HOME/esb_bak/up$cdate.log
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "step 0:检查是否有更新包...."
enum=0
mnum=0
i=0
cd $HOME/esb_bak
if [ ! -d "SmartESB" ]
then
        echo "更新包中无SmartESB目录，请确认..........."
else
        enum=$enum+1
fi
if [ ! -d "SmartMOM" ]
then
        echo "更新包中无SmartMOM目录，请确认..........."
else
        mnum=$mnum+1
fi
i=$enum+$mnum
if [ $i -eq 0 ]
then
        echo "esb_bak目录无关联更新包,更新终止[$i]....."
        exit
fi
echo "                                                  "
echo "                                                  "
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "step 1:关闭进程..."
$UpdateDir/stopproc.sh
if [ $? -gt 0 ]
then
 exit;
fi
echo "关闭进程成功"
echo "                                                  "
echo "                                                  "
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "step 2:备份数据..."
cd $HOME
if [ $enum -eq 1 ]
then
        nowtime=`date "+%Y%m%d%H%M"`
        echo "-----------------------------------------------" > esb_bak/bak.log
        echo "$nowtime 备份SmartESB开始!!!!!" >> esb_bak/bak.log
	tar -cvf SmartESB$cdate.tar SmartESB >esb_bak/bak.log;
	mv SmartESB$cdate.tar esb_bak/.;
       	echo "全量备份SmartESB完成!!!!!"
        nowtime=`date "+%Y%m%d%H%M"`
        echo "$nowtime 备份SmartESB完成!!!!!" >> esb_bak/bak.log
        echo "-----------------------------------------------" >> esb_bak/bak.log
 
        $UpdateDir/bakfile.sh SmartESB >> esb_bak/bak.log
        tar -cvf esb_bak/SmartESBbak$cdate.tar esb_bak/SmartESBbak >> esb_bak/bak.log;
        echo "增量备份SmartESB完成!!!!!"
fi
if [ $mnum -eq 1 ]
then
        echo "-----------------------------------------------" >> esb_bak/bak.log
        echo "$nowtime 备份SmartMOM开始!!!!!" >> esb_bak/bak.log
	tar -cvf SmartMOM$cdate.tar SmartMOM >>esb_bak/bak.log;
	mv SmartMOM$cdate.tar esb_bak/.;
       	echo "全量备份SmartMOM完成!!!!!"
        nowtime=`date "+%Y%m%d%H%M"`
        echo "$nowtime 备份SmartMOM完成!!!!!">> esb_bak/bak.log

        $UpdateDir/bakfile.sh SmartMOM >> esb_bak/bak.log
        tar -cvf esb_bak/SmartMOMbak$cdate.tar esb_bak/SmartMOMbak >> esb_bak/bak.log;
        echo "增量备份SmartMOM完成!!!!!"
fi
echo "数据备份完成!!!!!"
echo "                                                  "
echo "                                                  "
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "step 3:覆盖安装包..."
cd $HOME/esb_bak
i=0
if [ ! -d "SmartESB" ]
then
	echo "更新包中无SmartESB目录，请确认..........."
else
	cp -R  $HOME/esb_bak/SmartESB $HOME/.
	tar -cvf SmartESB_add_$cdate.tar $HOME/esb_bak/SmartESB>>bak.log
	rm -fr $HOME/esb_bak/SmartESB
	chmod -R 755 $HOME/SmartESB
        i=$i+1
fi
if [ ! -d "SmartMOM" ]
then
	echo "更新包中无SmartMOM目录，请确认..........."
else
	cp -R  $HOME/esb_bak/SmartMOM $HOME/.
	tar -cvf SmartMOM_add_$cdate.tar $HOME/esb_bak/SmartMOM>>bak.log
	rm -fr $HOME/esb_bak/SmartMOM
	chmod -R 755 $HOME/SmartMOM
        i=$i+1
fi
if [ $i -eq 0 ]
then
	echo "e_bak目录无关联更新包,请确认......"
        exit
fi
echo "安装包更新完成"
echo "                                                  "
echo "                                                  "
echo "=================================================="
echo "                                                  "
echo "                                                  "
echo "step4:开始启动进程........."

$UpdateDir/startproc.sh

echo "                                                  "
echo "                                                  "
echo "=================================================="
