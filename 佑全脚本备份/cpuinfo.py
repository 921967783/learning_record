#ecoding:utf-8
#!/usr/bin/env python
from email.mime.text import MIMEText
from email.header import Header
from smtplib import SMTP_SSL
import smtplib
import sys
import json
import os
import time
maxcpu=int(70)
maxmemory=int(50)
cpuinfodist={}
memoryinfodist={}
localtime=time.ctime()


os.system('if [ ! -d /tmp/cpuget ]; then  mkdir /tmp/cpuget;fi')
os.system('top -b -n 1 > /tmp/cpuget/.top.txt')
Avail=os.popen("df -h|grep /dev/vda1|awk '{print $4}' ").read()
cpuinfo1=os.popen("tail -n +8 /tmp/cpuget/.top.txt |awk '{print $1,$9,$10,$12}'|sort -k2r|awk '{print $1,$2,$4}'|head -10").read()
memoryinfo1=os.popen("tail -n +8 /tmp/cpuget/.top.txt |awk '{print $10,$1,$12}'|sort -gr|awk '{print $2,$1,$3}'|head -10").read()
print(cpuinfo1)
#cpuinfo1=cpuinfo1.join()
#memoryinfo1=memoryinfo1.join()
# cpuinfo1='12914 3.9 firefox 12580 2.0 java 18353 2.0 java 23076 2.0 prometheus 30455 0.0 java 17443 0.0' \
#          ' java 26725 0.0 java 14051 0.0 java 10677 0.0 java 2980 0.0 java'
# memoryinfo1='18353 13.0 java 2980 12.8 java 1910 12.4 java 29398 10.3 java 12580 9.7 java 30455 9.4 java' \
#             ' 17443 6.5 java 26725 4.5 java 14051 4.3 java 10677 2.3 java'
print(cpuinfo1.split()[2])

cpuinfo2=cpuinfo1.split()
memoryinfo2=memoryinfo1.split()
for i in range(1,30,3):
    cpuinfodist[cpuinfo2[i-1]]=[cpuinfo2[i],cpuinfo2[i+1]]
#print(cpuinfodist['19303'])
for i in range(1,30,3):
    memoryinfodist[memoryinfo2[i-1]]=[memoryinfo2[i],memoryinfo2[i+1]]
#print(memoryinfodist['18353'])

global countest

str1 = sys.argv[1]

def cputest(argv1,argv2,argv3):
    countest=0
    for cpuvalue in cpuinfodist.values():
        # print(cpuvalue[0])
        if  float(cpuvalue[0]) > maxcpu:
            # print('chaol')
            countest +=1
            break
    for memoryvalue in memoryinfodist.values():
        # print(memoryvalue[0])
        if  float(memoryvalue[0]) > maxmemory:
            # print('chaol')
            # emailit()
            countest += 1
            break
    print(countest)
    if countest >=1:
        emailit(argv1,argv2,argv3)
    
# def memorytest():
#     for memoryvalue in memoryinfodist.values():
#         # print(memoryvalue[0])
#         if  float(memoryvalue[0]) < maxmemory:
#             # print('chaol')
#             # emailit()
#             countest()
#             break
def logout():
    with open('/tmp/cpuget/cmemory.log','a+') as logfile:
        logfile.write(localtime + '  cpu' +  '\n ' + cpuinfo1)
        logfile.write(localtime +  '   内存' + '\n ' + memoryinfo1)

#cpu和内存报警
mail_content1 = '116数据层' + '\n' + 'cpu信息' + '\n' + cpuinfo1 + '\n' + '内存信息' +'\n' + memoryinfo1
mail_title1 = '服务器cpu内存报警邮件'
receiver_list1=['c921967783@qq.com','cy@hangzhouyq.com','wy@hangzhouyq.com','247608134@qq.com','363170930@qq.com']
#磁盘空间报警，116数据清理
mail_content2 = '116日志在' + localtime + '被清理过一次，如果频繁的话基本不是由于日志导致磁盘空间不足，需要检查' + '\n' + '清理后跟目录剩余磁盘空间为： ' + Avail
mail_title2 = '116日志清理，如果频繁请注意'
receiver_list2=['c921967783@qq.com','cy@hangzhouyq.com','wy@hangzhouyq.com','247608134@qq.com','363170930@qq.com']



def emailit(mail_content,mail_title,receiver_list):
    # qq邮箱smtp服务器
    host_server = 'smtp.qq.com'
    # sender_qq为发件人的qq号码
    sender_qq = '2301223813'
    # pwd为qq邮箱的授权码
    pwd = 'gqufooyrlazneaid'
    # 发件人的邮箱
    sender_qq_mail = '2301223813@qq.com'
    # 收件人邮箱
    # receiver = 'c921967783@qq.com'
    # receiver2 = 'cy@hangzhouyq.com'
    # receiver3 = 'wy@hangzhouyq.com'
    # 邮件的正文内容
    # mail_content = '116数据层' + '\n' + 'cpu信息' + '\n' + cpuinfo1 + '\n' + '内存信息' +'\n' + memoryinfo1
    # 邮件标题
    # mail_title = '服务器cpu内存报警邮件'

    # ssl登录
    smtp = SMTP_SSL(host_server)
    # set_debuglevel()是用来调试的。参数值为1表示开启调试模式，参数值为0关闭调试模式
    smtp.set_debuglevel(1)
    smtp.ehlo(host_server)
    smtp.login(sender_qq, pwd)

    msg = MIMEText(mail_content, "plain", 'utf-8')
    msg["Subject"] = Header(mail_title, 'utf-8')
    msg["From"] = sender_qq_mail
    
    for i in receiver_list:
        msg["To"] = i
        smtp.sendmail(sender_qq_mail, i, msg.as_string())
    smtp.quit()
if __name__ == "__main__":
    cputest(mail_content1,mail_title1,receiver_list1)
    if str1 == 'error':
        emailit(mail_content2,mail_title2,receiver_list2)
    # memorytest()
    logout()
