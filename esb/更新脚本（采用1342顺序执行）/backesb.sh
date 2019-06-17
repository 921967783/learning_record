cd $HOME/SmartESB/bin/ESBupdate
backlog=`echo $HOME/esb_bak/back.log`
clear
i=1
while [ $i = 1 ]
do
  echo "请输入服务接入渠道: (指定单渠道如CBSII,若不指定请输入n)"
  read channel
  if [ X"$channel" = X ]
  then
        echo "渠道参数不能为空值，请检查！！！"
  elif [ "$channel" = n ]
  then
       i=0
  elif [ ! -d "$HOME/SmartESB/configs/in_conf/metadata/$channel" ]
  then
       echo " channel $channel not exist ! "
  else
       i=0
  fi
done

i=1
while [ $i = 1 ]
do 
    echo "请输入服务号+场景号:(若不指定请输入n)"
    read servicecodes
    if [ X"$servicecodes" = X ]
    then
        echo "渠道参数不能为空值，请检查！！！"
    else
       i=0
    fi
done

i=1
while [ $i = 1 ]
do
    echo "其他文件路径(多个文件以;分隔,若不指定请输入n):\n"
    read filepathname
    if [ X"$filepathname" = X ]
    then
        echo "其他参数项不能为空值，请检查！！！"
    else
        i=0
    fi 
done
#filepath=`echo $filepathname|awk -F ":" '{print $1}'`
#filepath=`echo $filepathname|awk -F ":" '{print $2}'`;

echo "请确认要回退的服务:渠道名["$channel"] 服务码["$servicecodes"] 文件路径+文件名["$filepathname"](y/n)"
read ans
if [ "$ans" = "y" ]
then
    if [ "$channel" = "n" ]
    then
        if [ "$servicecodes" != "n" ]
        then 
            backservice=`echo "$servicecodes"|tr ';' '\n'` 
            for servicecode in $backservice 
            do 
                nowtime=`date "+%Y%m%d%H%M"`
                echo "-------------------------------------------------------------------------"|tee -a $backlog
                echo "$nowtime backservice.sh $servicecode start!!"|tee -a $backlog
                ./backservice.sh $servicecode |tee -a $backlog
                echo "$nowtime backservice.sh $servicecode end!!"|tee -a $backlog
                echo "-------------------------------------------------------------------------"|tee -a $backlog
            done 
        fi
    else     
       if [ "$servicecodes" != "n" ]
       then
        backservice=`echo "$servicecodes"|tr ';' '\n'`
            for servicecode in $backservice
            do
                nowtime=`date "+%Y%m%d%H%M"`
                echo "-------------------------------------------------------------------------"|tee -a $backlog
                echo "$nowtime backchservice.sh $channel $servicecode start!!"|tee -a $backlog
                ./backchservice.sh $channel $servicecode|tee -a $backlog
                echo "$nowtime backchservice.sh $channel $servicecode end!!"|tee -a $backlog
                echo "-------------------------------------------------------------------------"|tee -a $backlog
            done
       fi
    fi
    if [ "$filepathname" = "n" ]
    then 
        exit
    else
       backfiles=`echo "$filepathname"|tr ';' '\n'` 
       for backfile in $backfiles
       do
        nowtime=`date "+%Y%m%d%H%M"`
        echo "---------------------------------------------------------------------------"|tee -a $backlog
        echo "$nowtime backfile.sh $backfile start!!"|tee -a $backlog
        echo "backfile.sh $backfile "|tee -a $backlog
        ./backfile.sh $backfile |tee -a $backlog 
        echo "$nowtime backfile.sh $backfile end!!"|tee -a $backlog 
        echo "-------------------------------------------------------------------------"|tee -a $backlog 
       done
    fi
else
    exit
fi   
 
