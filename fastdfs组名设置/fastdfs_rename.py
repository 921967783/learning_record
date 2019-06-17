import os
import time
test_dict={}
finaList=[]
dateTime = time.strftime('%Y%m',time.localtime(time.time()))
fileName='portList%s.txt' % str(int(dateTime)-1)
newFileName='portList%s.txt'  % dateTime
with open(fileName,'r',encoding='utf-8') as f:
    all_dict =eval(f.read())
# newTime = time.strftime("%Y%m ", time.localtime())
# for key,values in all_dict:
#     print(key)
for key,value in all_dict.items():
    # print(value)
    pass
maxKey = max(all_dict,key=all_dict.get)
maxValue = all_dict[maxKey]
newPortList = [ x+int(maxValue) for x in range(1,19)  ]
print (newPortList)
text1="find ./ -name test -type f|xargs sed -i 's/"
finaList=[ text1 for i in range(len(all_dict))]
# print(finaList)
num =0
for values in all_dict.values():
    # ret2 ="port=%s/" % values
    ret2 = "%s/" % values
    finaList[num] = finaList[num] + ret2
    num +=1

for i in range(len(newPortList)):
    # print('port='+all_dict[i].keys())
    # ret1='port='+str(newPortList[i])
    ret1 = str(newPortList[i])
    finaList[i]=finaList[i] + ret1+ "/g'|sh"
    # print(finaList[i])

# print(finaList)
for i in range(len(all_dict)):
    # print(type(finaList[i]))
    code = (list(all_dict.values())[i])
    finaList[i] = finaList[i].replace('test',"'*%s*'" % code)
    print(finaList[i])

#重命名配置文件
#例如：storage201902_df_oldport.conf  改成 storage201902_df_newport.conf
text2 = "find ./ -name 'test1' -type f|sed 's/\(.*\)\(test2\)\(.*\)/mv \\1\\2\\3 \\1test3\\3/'|sh"
# print(text2)
mv_configure =[ text2 for i in range(len(all_dict))]
for i in range(len(all_dict)):
    code1 = (list(all_dict.values())[i])
    code2 = newPortList[i]
    mv_configure[i] =mv_configure[i].replace('test1',"*%s*" % code1)
    mv_configure[i] = mv_configure[i].replace('test2', "%s" % code1)
    mv_configure[i] = mv_configure[i].replace('test3', "%s" % code2)
    print(mv_configure[i])

#批量创建文件夹
#定义日期
#这个是针对配置文件修改后才能执行的，就改了个日期，例如把201902改成20192，然后批量创建，取其中一个就可以了。
#
date = dateTime
date_final = dateTime[1:-2] + dateTime[-1]
text3 = "find ./ -name '*test1*' -type f|sed 's/\(.*\)\(test2\)\(.*\)\(.conf\)/mkdir  \/fastdfs2\/storage_data\/20193\/storagetest3\\3/'|sh"
md_dist = [text3 for i in range(len(all_dict))]
for i in range(len(all_dict)):
    code3 = (list(all_dict.values())[i])
    code4 = newPortList[i]
    md_dist[i] = md_dist[i].replace('test1',"%s" % date)
    md_dist[i] = md_dist[i].replace('test2', "%s" % date)
    md_dist[i] = md_dist[i].replace('test3', "%s" % date_final,2)

#生成新的组和port一一对应的字典，供下个月使用
index=0
new_all_dict ={}
for key,value in all_dict.items():
    new_all_dict[key] = newPortList[index]
    index +=1
with open(newFileName,'w',encoding='utf-8') as f:
    f.write(str(new_all_dict))

# print(finaList)
# print(mv_configure)
print(md_dist[1])