#! /bin/bash
:<< BLOCK
Author's name: Little orange cat
Description: This is a PHP installation script, version 8.0.7

作者名称:小橘猫
描述:这是一个PHP安装脚本，版本为8.0.7
BLOCK

php_install_dir="/usr/local/php"
pack_wget="/opt/php-8.0.7.tar.gz"
pack_tar="/opt/php-8.0.7"
sock="/tmp/mysql.sock"

wget -O $pack_wget https://www.php.net/distributions/php-8.0.7.tar.gz
tar -zxvf $pack_wget -C /opt/
if [ $? -eq 0 ]
  then
    cd $pack_tar 
    ./configure --prefix=$php_install_dir --enable-fpm --with-mysql --enable-mysqlnd --with-mysql-sock=$sock --with-pdo-mysql=mysqlnd
    make -j 8 && make install -j 8
    if [ $? -eq 0 ]
      then
        echo "php安装成功，下面进行基本配置"
        read -p "输入你作为网站访问的IP:" ip
        useradd -r -s /sbin/nologin www-data
        cp $pack_tar/php.ini-development $php_install_dir/php.ini
        cp $php_install_dir/etc/php-fpm.d/www.conf.default  $php_install_dir/etc/php-fpm.d/www.conf
        cp $pack_tar/sapi/fpm/php-fpm $php_install_dir/bin/
        sed -r -i.bak "s/nobody/www-data/g" $php_install_dir/etc/php-fpm.d/www.conf
        sed -r -i.bak "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" $php_install_dir/php.ini 
        sed -r -i.bak "s/127.0.0.1/$ip/g" $php_install_dir/etc/php-fpm.d/www.conf
        cd $php_install_dir/etc/;mv php-fpm.conf.default php-fpm.conf
        cd $php_install_dir/bin/;./php-fpm
        if [ $? -eq 0 ];then echo "php配置成功";else echo "php配置失败";fi
    fi
fi
