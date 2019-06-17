destdir=$HOME
bakdir=$HOME/esb_bak
#echo $1
bakdir1=`dirname $1|sed 's/\/home\/esb\///g'` 
#echo $bakdir1
esbormom=` echo $bakdir1|awk -F "/" '{print $1}'`
bakfiledir=`echo $bakdir1|awk -F "/" -v OFS='/' '{$1="";print $0}'|sed 's/^\///g'`
#echo $bakdir1
#echo $esbormom
bakfiledir=`echo $bakfiledir`
bakfilename=` echo $1|awk -F "/" '{print $NF}`

cd $destdir
  #echo $bakfiledir
  #echo $bakfilename
  if [ ! -a $bakdir/$esbormom"bak/"$bakfiledir/$bakfilename ];then
    echo $bakdir/$esbormom"bak/"$bakfiledir/$bakfilename" not exsit " 
  else
    
    echo $bakdir/$esbormom'bak/'$bakfiledir/$bakfilename to $destdir/$esbormom/$bakfiledir/$bakfilename
    cp $bakdir/$esbormom'bak/'$bakfiledir/$bakfilename  $destdir/$esbormom/$bakfiledir/$bakfilename
  fi
#done
