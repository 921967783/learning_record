destdir=$HOME/SmartESB
bakdir=$HOME/esb_bak/SmartESBbak
indir='/configs/in_conf/metadata'
outdir='/configs/out_conf/metadata'
#echo $1
#echo $2
channel=$1
servicecode=$2

#in端服务回退
infile='service_'$servicecode'.xml'
inchannelfile='channel_'$channel'_service_'$servicecode'.xml'
inservicefile='service_'$servicecode'_system_'$channel'.xml'
if [ ! -a $bakdir$indir/$infile ]
then
   echo "$bakdir$indir/$infile not exit!!"
else
   echo "$bakdir$indir/$infile to  $destdir$indir/$infile"
   cp $bakdir$indir/$infile  $destdir$indir/$infile
fi
if [ ! -a $bakdir$indir/$channel/$inchannelfile ]
then
    echo "$bakdir$indir/$channel/$inchannelfile not exit!!" 
else
    echo $bakdir$indir/$channel/$inchannelfile to  $destdir$indir/$channel/$inchannelfile
    cp $bakdir$indir/$channel/$inchannelfile  $destdir$indir/$channel/$inchannelfile
fi
if [ ! -a $bakdir$indir/$channel/$inservicefile ]
then
   echo "$bakdir$indir/$channel/$inservicefile not exit!!" 
else
   echo $bakdir$indir/$channel/$inservicefile to  $destdir$indir/$channel/$inservicefile
   cp $bakdir$indir/$channel/$inservicefile  $destdir$indir/$channel/$inservicefile
fi

#ls -ltr $destdir$indir/$infile
#ls -ltr $destdir$indir/$channel/$inchannelfile
#ls -ltr $destdir$indir/$channel/$inservicefile

#out端服务回退
cd $destdir$outdir
outfiles=`find . -name '*'$servicecode'*'`
#echo $outfiles
for outfile in $outfiles
do
  outfiledir=`dirname $outfile|awk -F "." '{print $2}'`
  outfilename=`echo $outfile|awk -F "/" '{print $NF}'`
  echo $bakdir$outdir$outfiledir/$outfilename to $destdir$outdir$outfiledir/$outfilename
  cp $bakdir$outdir$outfiledir/$outfilename  $destdir$outdir$outfiledir/$outfilename
done
