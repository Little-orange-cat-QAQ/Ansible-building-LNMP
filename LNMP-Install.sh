#! /bin/bash
echo "替换YUM源，安装依赖环境"
bash environment.sh
if [ $? -eq 0 ];then echo "环境安装完成";else echo "环境安装失败";exit 1;fi

echo "安装Mysql"
bash mysql_install.sh
if [ $? -eq 0 ];then echo "Mysql安装完成";else echo "Mysql安装失败";exit 1;fi

echo "安装PHP"
bash php_install.sh
if [ $? -eq 0 ];then echo "PHP安装完成";else echo "PHP安装失败";exit 1;fi

echo "安装Nginx"
bash nginx_install.sh
if [ $? -eq 0 ];then echo "Nginx安装完成";else echo "Nginx安装失败";exit 1;fi
