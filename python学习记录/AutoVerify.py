#coding:utf-8
import json
import socket
import sys
import urllib.request

import selenium.common.exceptions as ex
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import  expected_conditions as ec
from selenium.webdriver.support.ui import WebDriverWait

def read_json_file(json_file):
        with open(json_file,"r") as jsonfile:
            json_config = json_load(jsonfile)
        return json_config

def login(config):
    url = config['host']
    port = config['port']
    only = config['onlyopen']
    if port:
        #端口测试
        sk = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        sk.settimeout(3)
        try:
            sk.connect((str(url),int(port)))
            print("port is connect")
        except Exception:
            raise Exception('port not connect')
        finally:
            sk.close()
    elif only == 1:
        #只测试页面
        try:
            code = urllib.request.urlopen(url).code
            while True:
                if code == 200:
                    print("page is open")
                    break
        except Exception:
            raise Exception('page not open')
    else:
        #页面登录测试
        options = webdriver.ChromeOptions()
        browser = webdriver.Chrome(executable_path="chromedriver.exe",options=options)
        browser.set_page_load_timeout(30)
        browser.implicitly_wait(5)
        try:
            code = urllib.request.urlopen(url).code
            while True:
                if code == 200:
                    browser.get(url)
                    check = 0
                    if config['userId']:
                        username = browser.find_element_by_id(config['userId'])
                    else:
                        username = browser.find_element_by_name(config['userName'])
                    if config['pwdId']:
                        pwd = browser.find_element_by_id(config['pwdId'])
                    else:
                        pwd = browser.find_element_by_name(config['pwdName'])
                    if config['subId']:
                        submit = browser.find_element_by_id(config['subId'])
                    elif config['subName']:
                        submit = browser.find_element_by_name(config['subName'])
                    else:
                        check = 1
                        submit = config['subJS']
                    username.send_keys(config['account'])
                    pwd.send_keys(config['pwd'])
                    if check == 0:
                        submit.send_keys(Keys.RETURN)
                    elif check ==1:
                        browser.execute_script(submit)
                    WebDriverWait(browser,10).until(ec.url_changes(config['host']))
                    print(browser.current_url)
                    break
        except Exception:
            raise Exception('login not ok')
        finally:
            browser.quit()

def __main__():
    json_file = sys.argv[1]
    #json_file = 'config/esb.json'
    config = read_json_file(json_file)
    login(config)

if __name__ == "__main__":
    __main__()