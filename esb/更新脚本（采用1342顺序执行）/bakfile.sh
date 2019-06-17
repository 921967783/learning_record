updatedir=$HOME/esb_bak/$1
sourcedir=$HOME/$1
bakdir=$HOME/esb_bak/$1bak
nowtime=`date "+%Y%m%d%H%M"`
#检查更新包
if [ ! -d $updatedir ]
then
  echo "$nowtime 更新包中无$1目录，请确认..........."
  exit
fi
echo "----------------------------------------------------------"
echo "$nowtime 备份$1增量包开始"
if [ ! -d $bakdir ]
then
    mkdir $bakdir
fi

mkchilddir(){
 #pwd
 #echo $1
 childdirs=`echo $1|awk -F "/" '{for (i=2;i<NF;i++){print $i }}'`
 for childdir in $childdirs
 do
   if [ ! -d $childdir ];then
     mkdir $childdir
   fi
   cd $childdir
   #echo mkdchilddir:`pwd`
 done
}


cd $updatedir
updatefiles=`find . -type f`
#echo $updatefiles
for updatefile in $updatefiles
do
  bakfiledir=`dirname $updatefile|awk -F "." '{print $2}'`
  bakfilename=`echo $updatefile|awk -F "/" '{print $NF}'`
  #echo $bakfiledir
  #echo $bakfilename
  cd $bakdir
  mkchilddir $bakfiledir/
  if [ -a $sourcedir/$bakfiledir/$bakfilename ]
  then
      cp -rf $sourcedir$bakfiledir/$bakfilename $bakdir$bakfiledir/$bakfilename
      echo $sourcedir$bakfiledir/$bakfilename --To-- $bakdir$bakfiledir/$bakfilename 
  else
      echo "$sourcedir$bakfiledir/$bakfilename not exist"
  fi 
done

echo "$nowtime 备份$1增量包结束"
echo "----------------------------------------------------------"
