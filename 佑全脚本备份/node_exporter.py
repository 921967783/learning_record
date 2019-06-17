import paramiko
import pymysql
import time
from email.mime.text import MIMEText
from email.header import Header
from smtplib import SMTP_SSL
import smtplib
import sys
import json
import os


distAll ={}
_colLength=0
#tmplist[0]=port&&tmplist[1]=cpustatus&&tmplist[2]=singlemaxcup&&tmplist[3]=memorystatus&&tmplist[4]=singlemaxmemory
#tmplist[5]=mysqlslave&&tmplist[6]=mysqlThreec&&tmplist[7]=msyqlmaxThreed&&tmplist[8]=username&&tmplist[9]=passwd
tmpList = []
# cpuinfodist={}
# memoryinfodist={}
localtime=time.ctime()

def get_mysqlList():
    db = pymysql.connect('47.98.142.158', 'root', 'root', 'python', charset='utf8')
    cursor = db.cursor()
    sql = 'select * from node_exporter'
    global _colLength
    global tmpList
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        for row in results:
            if row[12] == 1:
                ip = row[1]
                tmpList = [ row[i+1] for i in range(len(row)-1)]
                distAll[ip] = tmpList
                _colLength += 1


    except Exception:
        raise Exception("Error: unable to fecth data")
    finally:
        db.close()

def sshconnect(ip,port,user,passwd):
    #实例化ssh客户端
    ssh = paramiko.SSHClient()
    #创建默认的白名单
    policy = paramiko.AutoAddPolicy()
    #设置白名单
    ssh.set_missing_host_key_policy(policy)
    #链接服务器
    ssh.connect(
        hostname = ip, #服务器的ip
        port = port, #服务器的端口
        username = user, #服务器的用户名
        password =  passwd#用户名对应的密码
    )
    return ssh

global countest


def cputest(value):
    countest=0
    print(cpuinfodist)
    print(memoryinfodist)
    for cpuvalue in cpuinfodist.values():
        # print(cpuvalue[0])
        if  float(cpuvalue[0]) > distAll[value][3]:
            # print('chaol')
            # print(cpuvalue[0])
            countest +=1
            break
    for memoryvalue in memoryinfodist.values():
        # print(memoryvalue[0])
        if  float(memoryvalue[0]) > distAll[value][5]:
            # print('chaol')
            # emailit()
            # print(memoryvalue[0])
            countest += 1
            break
    print(countest)
    if countest >=1:
        emailit_test(mail_content1,mail_title1,receiver_list1)
        # pass
def mysqlthread_test():
    if int(mysqlthread) > 160:
        emailmysql_thread()
def logout():
    with open('/tmp/cpuget/cmemory.log','a+') as logfile:
        logfile.write(localtime + '  cpu' +  '\n ' + cpuinfo1)
        logfile.write(localtime +  '   内存' + '\n ' + memoryinfo1)


#邮件函数
def emailit_test(mail_content,mail_title,receiver_list):
    # qq邮箱smtp服务器
    # host_server = 'smtp.qq.com'
    host_server = 'smtp.exmail.qq.com'
    # sender_qq为发件人的qq号码
    sender_qq = 'zq@hangzhouyq.com'
    # pwd为qq邮箱的授权码
    # pwd = 'gqufooyrlazneaid'
    pwd='Nz6Tof4qdhVATLCw'
    # 发件人的邮箱
    sender_qq_mail = 'zq@hangzhouyq.com'
    # 收件人邮箱
    # receiver = 'c921967783@qq.com'
    # 邮件的正文内容
    # mail_content = 'cpu信息' + '\n' + cpuinfo1 + '\n' + '内存信息' +'\n' + memoryinfo1
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
        msg["From"] = sender_qq_mail
        for i in receiver_list:
            msg["To"] = i
            smtp.sendmail(sender_qq_mail, i, msg.as_string())
        smtp.quit()

#各报警信息编辑
#1.cpu报警
mail_title1 = '服务器cpu内存报警邮件'
# receiver_list1=['c921967783@qq.com','cy@hangzhouyq.com','158355257@qq.com','247608134@qq.com','363170930@qq.com','ecme74@163.com']
receiver_list1=['c921967783@qq.com']

#2.mysql连接数报警
mail_title2 = 'mysql连接数报警'
receiver_list2=['c921967783@qq.com','cy@hangzhouyq.com','158355257@qq.com','247608134@qq.com','363170930@qq.com']

# mail_content = '122从mysql服务器' + '\n' + '连接数为' + mysqlthread + '\n'
#3.mysql主从报警
mail_title3='mysql主从报警'
receiver_list3=['c921967783@qq.com','cy@hangzhouyq.com','158355257@qq.com','247608134@qq.com','363170930@qq.com']

get_mysqlList()
# print(distAll)
count =0
for value in distAll.keys():
    print(value)
    ssh = sshconnect(value,distAll[value][1],distAll[value][9],distAll[value][10])
    # print(ssh)
    ssh.exec_command("if [ ! -d /tmp/cpuget ]; then  mkdir /tmp/cpuget;fi")
    ssh.exec_command("top -b -n 1 > /tmp/cpuget/.top.txt")
    #貌似有冲突读取不到文件内容，使用定了延迟一秒，现在正常
    time.sleep(1)

    # stdin1, stdout1, stderr1 =ssh.exec_command("ifconfig |grep -A 2 eth0|grep inet|awk '{print $2}'|awk -F ':' '{print $2}'")
    stdin2, stdout2, stderr2 = ssh.exec_command("tail -n +8 /tmp/cpuget/.top.txt |awk '{print $1,$9,$10,$12}'|sort -k2r|awk '{print $1,$2,$4}'|head -10")
    cpuinfo1 = stdout2.readlines()
    cpuinfo1 = [i.replace("\n", "") for i in cpuinfo1]
    stdin3, stdout3, stderr3 =ssh.exec_command("tail -n +8 /tmp/cpuget/.top.txt |awk '{print $10,$1,$12}'|sort -gr|awk '{print $2,$1,$3}'|head -10")
    memoryinfo1 = stdout3.readlines()
    memoryinfo1 = [i.replace("\n", "") for i in memoryinfo1]
    if distAll[value][7] == 1:
        # print('11111111111')
        stdin4, stdout4, stderr4 =ssh.exec_command("/usr/local/mysql/bin/mysqladmin -uroot -p@hzyqroot-2018-new -h%s status|awk '{print $4}'" % value)
        mysqlthread = stdout4.readlines()
        mysqlthread = mysqlthread[0].replace("\n", "")
        # print(mysqlthread)
        mail_content2 = distAll[value][0] + 'mysql服务器' + '\n' + '连接数为' + mysqlthread + '\n'
        print(mail_content2)
        if int(mysqlthread) > distAll[value][8]:
            # print('YES_Thread')
            emailit_test(mail_content2,mail_title2,receiver_list2)

    if distAll[value][6] == 1:
        # print('2222222222')
        stdin5, stdout5, stderr5 =ssh.exec_command("mysql -uroot -p@hzyqroot-2018-new -e 'show slave status\G'|grep  Slave_IO_Running|awk '{print $2}'")
        stdin6, stdout6, stderr6 =ssh.exec_command("mysql -uroot -p@hzyqroot-2018-new -e 'show slave status\G'|grep  Slave_SQL_Running:|awk '{print $2}'" )
        mysqlSlaveStatus1 = stdout5.readlines()
        mysqlSlaveStatus2 = stdout6.readlines()
        mysqlSlaveStatus1 = mysqlSlaveStatus1[0].replace("\n", "")
        mysqlSlaveStatus2 = mysqlSlaveStatus2[0].replace("\n", "")
        # print(mysqlSlaveStatus1)
        # print(mysqlSlaveStatus2)
        mail_content3 = distAll[value][0] + '从mysql服务器' + '\n' + 'Slave_IO_Running:  ' + mysqlSlaveStatus1 + '\n' + 'Slave_SQL_Running:  ' + mysqlSlaveStatus2  + '\n'
        print(mail_content3)
        if mysqlSlaveStatus1 == mysqlSlaveStatus2 == 'Yes':
            pass
        else:
            emailit_test(mail_content3,mail_title3,receiver_list3)
            
    # print(cpuinfo1)
    # print(memoryinfo1)
    cpuinfo2 = []
    for i in cpuinfo1:
        cpuinfo2 += i.split()
    # print(cpuinfo2)
    memoryinfo2 = []
    for i in memoryinfo1:
        memoryinfo2 += i.split()
    # print(memoryinfo2)
    cpuinfodist={}
    memoryinfodist={}
    print(len(cpuinfo2))
    print(len(memoryinfo2))
    for i in range(1, 30, 3):
        cpuinfodist[cpuinfo2[i - 1]] = [cpuinfo2[i], cpuinfo2[i + 1]]
    # print(cpuinfodist['19303'])
    for i in range(1, 30, 3):
        memoryinfodist[memoryinfo2[i - 1]] = [memoryinfo2[i], memoryinfo2[i + 1]]
    count +=1
    #print(distAll[value])
    #监控cpu内存
    mail_content1 = distAll[value][0] + '线上服务器' + '\n' + 'cpu信息' + '\n' + " ".join(cpuinfo1) + '\n' + '内存信息' + '\n' + " ".join(memoryinfo1)
    print(mail_content1)
    cputest(value)

# cpuinfo1 = [i.split() for i in cpuinfo1]





