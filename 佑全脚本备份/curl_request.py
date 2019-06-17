#coding:utf-8

import paramiko
import pymysql
import os
from email.mime.text import MIMEText
from email.header import Header
from smtplib import SMTP_SSL

ip_list=[]
command_list=[]
port_list =[]
description = []
description_list = []
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

def getconnected(ip,username,passwd,command,port=22):
    """

    :param ip:
    :param username:
    :param passwd:
    :param port:
    :return:
    """
    ssh.connect(
        hostname=ip,
        username=username,
        password=passwd,
        port=port
    )
    stdin, stdout1, stderr = ssh.exec_command(command)
    result =stdout1.read().decode()
    ssh.close()
    return result

def mysqlconnect():
    colLength=0
    db = pymysql.connect('47.98.142.158', 'root', 'root', 'python', charset='utf8')
    cursor = db.cursor()
    sql = 'select * from curl_request'
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        for row in results:
            ip = row[1]
            command =row[2]
            port = row[3]
            description = row[4]
            ip_list.append(ip)
            command_list.append(command)
            port_list.append(port)
            description_list.append(description)
            colLength +=1
    except Exception:
        raise Exception("Error: unable to fecth data")
    finally:
        db.close()
        return colLength

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
        msg["To"] = i
        smtp.sendmail(sender_qq_mail, i, msg.as_string())
    smtp.quit()


if __name__ == '__main__':
    # final = getconnected('47.98.210.22','root','1OZNmDZF9B1BWkTA',
    #              "curl http://172.16.119.118:8101/zsacom/system/logins -d 'loginName=root&password=ct1993526&platform=1&ip&mac' -w %{http_code}| awk -F '}' '{print $2}'")
    mail_title1 = '线上项目  登录接口 post请求状态异常'
    receiver_list1 = ['c921967783@qq.com', 'cy@hangzhouyq.com', '158355257@qq.com', '247608134@qq.com',
                      '363170930@qq.com']
    col = mysqlconnect()
    try:
        for i in range(col):
            s = os.popen(command_list[i]).read()
            s.strip()
            if int(s) == 200:
                print('ok')
            else:
                mail_content1=('%s  ip%s  端口%s  登录接口请求异常，请速上线排查' %(description_list[i],ip_list[i],port_list[i]))
                emailit_test(mail_content1,mail_title1,receiver_list1)
    except Exception:
        mail_content1 = ('%s  ip%s  端口%s  登录接口请求异常，请速上线排查' % (description_list[i], ip_list[i], port_list[i]))
        emailit_test(mail_content1, mail_title1, receiver_list1)

