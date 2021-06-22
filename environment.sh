#! /bin/bash
:<< BLOCK
Author's name:Little orange cat
Description:This is a script to detect the LNMP installation dependencies

作者名称:小橘猫
描述:这是一个检测LNMP安装依赖的脚本
BLOCK
mkdir /opt/yum_pack
mv /etc/yum.repos.d/* /opt/yum_pack
wget -O /etc/yum.repos.d/huawei.repo https://repo.huaweicloud.com/repository/conf/CentOS-7-reg.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.cloud.tencent.com/repo/epel-7.repo
yum clean all && yum makecache

env=(gcc-c++ pcre pcre-devel zlib zlib-devel openssl openssl-devel make gcc gcc-c++ bison ncurses ncurses-devel openssl* rpcgen libtirpc-devel sqlite-devel openssl*  libtirpc-devel rpcgen* libxml2 libxml2-devel)
for i in ${env[@]}
  do
    if [ `rpm -qa | grep $i &> /dev/null;echo $?` -eq 0 ]
     then
	 echo -e "\033[42;37m $i安装成功了 \033[0m"
	 echo " "
    else
	 echo -e "\033[43;37m $i没有安装成功，正在为您安装中......\033[0m"
	 yum -y install $i &> /dev/null
	 if [ $? -eq 0 ];then echo -e "\033[42;37m $i安装成功了 \033[0m";echo " ";else echo -e "\033[41;36m $i安装失败，请检测你的YUM源哟 \033[0m";echo -e "\033[46;37m 可以执行Ansible-Playbook来替换YUM源哟！！！\033[0m";echo " ";fi
    fi
done
