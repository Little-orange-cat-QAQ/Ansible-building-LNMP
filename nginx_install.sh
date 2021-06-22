#! /bin/bash
:<< BLOCK
Author's name: Little orange cat
Description: This is an nginx installation script. The version of nginx is 1.14

作者名称:小橘猫
描述:这是一个Nginx安装脚本，Nginx的版本为1.14
BLOCK

useradd -r -s /sbin/nologin nginx
user="nginx"
group="nginx"
install_dir="/usr/local/nginx"
address="http://nginx.org/download/nginx-1.14.2.tar.gz"
name="nginx-1.14.2.tar.gz"
file_name="nginx-1.14.2"
echo "Nginx源码安装"
wget -O /opt/$name  $address &> /dev/null
tar -zxvf /opt/$name -C /opt/ &> /dev/null
cd /opt/$file_name
./configure --prefix=$install_dir --user=$user --group=$group  &> /dev/null
if [ $? -eq 0 ]
  then
    make -j 8 && make install -j 8 &> /dev/null
	 if [ $? -eq 0 ]
           then 
             read -p "输入用于网站的IP地址:" ip
             echo "进行php信息的配置"
             echo "<?php phpinfo(); ?>" >> $install_dir/html/index.php
             sed -i -r -e "64d" $install_dir/conf/nginx.conf
             sed -i -r -e "63a location ~ .php$ {" $install_dir/conf/nginx.conf 
             sed -i -r -e "65d" $install_dir/conf/nginx.conf
             sed -i "64,71 s/#/ /g" $install_dir/conf/nginx.conf
             sed -i -r -e "s/127.0.0.1/$ip/g;s/localhost/$ip/g" $install_dir/conf/nginx.conf
             sed -i -r -e '/fastcgi_param /a fastcgi_param SCRIPT_NAME $fastcgi_script_name;' $install_dir/conf/nginx.conf
             sed -i -r -e "45 c index index.php index.html index.htm;" $install_dir/conf/nginx.conf
             sed -i -r -e '68d;67a  fastcgi_param   SCRIPT_FILENAME    $document_root$fastcgi_script_name;' $install_dir/conf/nginx.conf
             cd $install_dir/sbin/;./nginx;curl http://192.168.1.100 &> /dev/null
             if [ $? -eq 0 ];then echo "Nginx安装配置成功";else echo "安装失败";fi
         fi
   else
       echo "依赖环境有问题，需要重新进行调试"
    fi
