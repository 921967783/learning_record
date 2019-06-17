#!/bin/bash
workspace='/root/.jenkins/workspace/'
workspace1=$workspace$1
echo $workspace1
#filepath=`find /root/.jenkins/workspace/pipeline-zsaGov-cicd/zsaGov -name 'env.properties'|grep -v 'target'`
filepath2=`find $workspace1 -name 'env.properties'|grep -v 'target'`
#echo $filepath
echo $filepath2
test=`cat $filepath2|egrep '^zas\.url.*zsa$'|awk -F ':' '{print $3}'|awk -F '/' '{print $1}'`
test1=`cat $filepath2|egrep '^zas\.url.*zsa$'`
test2=`cat $filepath2|egrep '^zas\.url.*zsa$'|sed "s/$test/$2/g"`
#testjust="\\/\\\\"
test11=`echo $test1|sed 's#\\\#\\\\\\\#g'`
test22=`echo $test2|sed 's#\\\#\\\\\\\#g'`
echo $test
echo $test11
echo $test22
#echo $test11
#sed -i 's/$test/$2/g' $filepath2
sed -i "s#${test11}#${test22}#g" $filepath2
echo "from $test change to $2"
