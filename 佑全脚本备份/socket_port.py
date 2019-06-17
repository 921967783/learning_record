#coding:utf-8

import socket
import pymysql
from email.mime.text import MIMEText
from email.header import Header
from smtplib import SMTP_SSL
import smtplib
import sys
import json

# s = [('75.34环境st老图片上传项目', '114.55.75.34', '80', 1), ('75.34环境fastdfs新图片上传项目负载1', '114.55.75.34', '9191', 1), ('75.34环境fastdfs上传测试项目', '114.55.75.34', '9305', 1), ('28.5环境安卓apk下载更新地址', '114.55.28.5', '80', 1), ('28.5环境行业咨询项目', '114.55.28.5', '8101', 1), ('28.5环境fastdfs新图片上传项目负载2', '114.55.28.5', '8102', 1), ('28.5环境张恒视频上传线上测试项目', '114.55.28.5', '8103', 1), ('116环境数据层负载1--123从库', '172.16.119.116', '8081', 0), ('116环境数据层负载2--115主库', '172.16.119.116', '8082', 0), ('116环境数据层负载3--122从库', '172.16.119.116', '8122', 0), ('118环境企业端负载1', '172.16.119.118', '8101', 0), ('118环境监管端负载1', '172.16.119.118', '8102', 0), ('118环境运营端负载1', '172.16.119.118', '8103', 1), ('118环境公众端负载1', '172.16.119.118', '8104', 1), ('118环境配送端负载1', '172.16.119.118', '8105', 0), ('118环境学校食堂负载1', '172.16.119.118', '8106', 0), ('118环境健康证项目', '172.16.119.118', '8107', 1), ('118环境生产流通项目', '172.16.119.118', '8108', 0), ('121环境企业端负载2', '172.16.119.121', '8101', 0), ('121环境监管端负载1', '172.16.119.121', '8102', 0), ('121环境运营端负载2', '172.16.119.121', '8103', 1), ('121环境公众端负载2', '172.16.119.121', '8104', 1), ('121环境配送端负载2', '172.16.119.121', '8105', 1), ('121环境学校食堂负载2', '172.16.119.121', '8106', 0), ('121线上灰度环境', '172.16.119.121', '8109', 0)]
#s_load两台负载服务器
s_load= ['172.16.119.118','172.16.119.121']
#存放在特例的情况，就是两台负载只要有一台起了相应服务就不会报警

ip_list=[]
port_list=[]
description_list =[]
_finalList = []
_colLength=0
specialport= ['8103','8104','8105','8106']
_specialport = ['8103','8104','8105','8106']
_specail_dist= {'8103':'线上运营端','8104':'线上公众端','8105':'线上配送端','8106':'线上学校食堂'}
#特殊处理的结果
special_result =[]
#普通匹配结果
normal_result=[]

def get_mysqlList():
    db = pymysql.connect('47.98.142.158', 'root', 'root', 'python', charset='utf8')
    cursor = db.cursor()
    sql = 'select * from socket_connect'
    global _colLength
    _colLength=0
    try:
        cursor.execute(sql)
        results = cursor.fetchall()
        for row in results:
            ip = row[1]
            port = row[2]
            description = row[3]
            # print ("ip=%s,port=%s,description=%s" % (ip,port,description))
            ip_list.append(ip)
            port_list.append(port)
            description_list.append(description)
            _colLength += 1

    except Exception:
        raise Exception("Error: unable to fecth data")
    finally:
        db.close()




def login(host,port):
    if host:
        sk =socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        sk.settimeout(3)
        try:
            sk.connect((str(host),int(port)))
            print('port is connect')
            return 1
        except :
            print('port not connect')
            return 0
        finally:
            sk.close()

def get_errorList(s):
    global special_result
    for i in s:
        if i[1] in s_load and i[2] in specialport :
            if i[3] == 1 and i[2] in _specialport:
                _specialport.remove(i[2])
                # print(i[2])
            else:
                pass
        else:
            normal_result.append(i)
    special_result = _specialport

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

#线上端口报警
# mail_content1='122从mysql服务器' + '\n' + '连接数为' + mysqlthread + '\n'
mail_title1='线上服务器问题'
receiver_list1=['c921967783@qq.com','cy@hangzhouyq.com','158355257@qq.com','247608134@qq.com','363170930@qq.com']

if __name__ =='__main__':
    #获取数据库列表数据和表行数
    get_mysqlList()
    #获取各环境端口socket连接状态
    for i in range(_colLength):
        print(description_list[i])
        s = login(ip_list[i], port_list[i])
        _final = (description_list[i], ip_list[i], port_list[i], s)
        _finalList.append(_final)
    #处理报警的数据列表
    get_errorList(_finalList)
    for i in special_result:
        # print(_specail_dist[i])
        mail_content1 = ('%s 端口 %s 异常，请上线排查问题' %(_specail_dist[i],i))
        emailit_test(mail_content1, mail_title1, receiver_list1)
    for i in normal_result:
        if i[3] == 0:
            # print(i)
            mail_content1 = ('%s %s 端口 %s 异常，请上线排查问题' % (i[0],i[1], i[2]))
            emailit_test(mail_content1,mail_title1,receiver_list1)
