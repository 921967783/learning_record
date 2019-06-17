destdir=$HOME/SmartESB
bakdir=$HOME/esb_bak/SmartESBbak
#indir='/configs/in_conf/metadata'
#outdir='/configs/out_conf/metadata'
#echo $1
servicecode=$1


cd $destdir
infiles=`find ./configs/in_conf -name '*'$servicecode'*'`
outfiles=`find ./configs/out_conf -name '*'$servicecode'*'`
bakfiles=$infiles" "$outfiles
#echo $bakfiles
for bakfile in $bakfiles
do
  #echo $outfile
  bakfiledir=`dirname $bakfile|awk -F "." '{print $2}'`
  bakfilename=`echo $bakfile|awk -F "/" '{print $NF}'`
  #echo $outfiledir
  #echo $outfilename
  if [ ! -a $bakdir$bakfiledir/$bakfilename ];then
    echo $bakdir$bakfiledir/$bakfilename" not exsit " 
  else
   echo "$bakdir$bakfiledir/$bakfilename to $destdir$bakfiledir/$bakfilename"  
   cp $bakdir$bakfiledir/$bakfilename  $destdir$bakfiledir/$bakfilename
  fi
done
