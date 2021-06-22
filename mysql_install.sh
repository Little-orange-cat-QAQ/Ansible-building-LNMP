#! /bin/bash
:<< BLOCK
Author's name: Little orange cat
Description: This is a MySQL database installation script, version 5.7.34

作者名称:小橘猫
描述: 这时一个MYSQL数据库安装脚本，版本为5.7.34
BLOCK

#MYSQL_install_dir
install_dir="/usr/local/mysql"
data_dir="/usr/local/mysql/data"
boost_pack="/opt/boost_1_59_0.tar.gz"
boost_pack_dir="/opt/boost_1_59_0"
mysql_pack="/opt/mysql-5.7.34.tar.gz"
mysql_pack_dir="/opt/mysql-5.7.34"


#Cmake_install"
cmake_pack="/opt/cmake-3.20.3.tar.gz"
cmake_pack_dir="/opt/cmake-3.20.3"
cmake_install_dir="/usr/local/cmake"

#Cmake install
wget -O $cmake_pack https://github.com/Kitware/CMake/releases/download/v3.20.3/cmake-3.20.3.tar.gz #&> /dev/null
tar -zxvf $cmake_pack -C /opt/ #&> /dev/null
    cd $cmake_pack_dir ; ./bootstrap #&> /dev/null
    if [ $? -eq 0 ]
       then
           ./configure --prefix=$cmake_install_dir
	   make -j 8 && make install -j 8 #&> /dev/null
           ln -s $cmake_install_dir/bin/cmake /usr/bin/cmake
           if [ $? -eq 0 ];then echo "camke安装完成";else echo "cmake安装失败";fi
    else
           echo "error"
    fi
    

#Mysql install
wget -O $boost_pack https://nchc.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz #&> /dev/null
wget -O $mysql_pack https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.34.tar.gz #&> /dev/null
tar -zxvf $boost_pack -C /opt/
tar -zxvf $mysql_pack -C /opt/
cd $mysql_pack_dir
cmake . -DCMAKE_INSTALL_PREFIX=$install_dir -DMYSQL_DATADIR=$data_dir -DWITH_BOOST=$boost_pack_dir -DSYSCONFDIR=/etc -DEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=all #&> /dev/null
       if [ $? -eq 0 ];then 
         make -j 8 && make install -j 8 #&> /dev/null
         echo "Mysql安装完成，现在执行数据库初始化"
         # 修改权限以及创建配置文件
         useradd -r -s /sbin/nologin mysql
         chown -R mysql.mysql /usr/local/mysql
         mkdir /var/log/mysql
         mkdir /var/run/mysql
         touch /var/log/mysqlmysql.log
         touch /var/run/mysql/mysql.pid
         chown -R mysql.mysql /var/log/mysql
         chown -R mysql.mysql /var/run/mysql
         chown -R mysql.mysql /usr/local/mysql
         cnf='/etc/my.cnf'
         echo "[mysqld]" > $cnf
         echo "character-set-server=utf8" >> $cnf
         echo "collation-server=utf8_general_ci" >> $cnf
         echo "user=mysql" >> $cnf
         echo "port=3306" >> $cnf
         echo "basedir=/usr/local/mysql" >> $cnf
         echo "datadir=/usr/local/mysql/data" >> $cnf
         echo "socket=/tmp/mysql.sock" >> $cnf
         echo "[mysqld_safe]" >> $cnf
         echo "log-error=/var/log/mysql/mysql.log" >> $cnf
         echo "pid-file=/var/run/mysql/mysql.pid" >> $cnf

         cd $install_dir;./bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data &> /var/log/mysql/mysql_info
         a="`cat /var/log/mysql/mysql_info | egrep -e 'root.*' | awk -F " " '{print $(NF-1),$(NF)}'`"
         echo "您的初始用户名和密码是  $a  它的信息保存在/var/log/mysql/mysql_info" 
         echo "后续的修改密码操作需要自行执行哟！！！"
         ln -s /usr/local/mysql/bin/mysql /usr/bin/
            if [ $? -eq 0 ]
              then 
                cp $install_dir/support-files/mysql.server /etc/init.d/mysqld;chkconfig --add mysqld;chkconfig mysqld on;systemctl start mysqld
                if [ $? -eq 0 ];then echo "Mysql配置完成";else echo "Mysql配置错误";fi
            fi
    fi






