#!/usr/bin/env bash
set -x
# Prepares VM with web server, opens ports on firewall
# install apache

#chown -R apache:apache /var/www/html
#chmod -R 644 /var/www/html
#find /var/www/html -type d -exec chmod ugo+rx {} \;

# centos 9 update - epel already in base VM created in westlife-eu/centos9
yum -y install epel-release
# add swap file as cloud micro instances may lack of memory
# https://stevescargall.com/2021/12/20/resolving-commands-killed-on-gcp-f1-micro-compute-engine-instances/
fallocate -l 2G /swapfile
mkswap /swapfile
chmod 0600 /swapfile
swapon /swapfile
if grep -q '/swapfile' /etc/fstab; then
  echo "swapfile already in fstab"
else
  echo "/swapfile swap swap defaults 0 0\n" >>/etc/fstab
  echo "adding /swapfile to fstab"
fi
#yum -y install epel-release
#yum-config-manager --save --setopt=epel/x86_64/metalink.skip_if_unavailable=true
#yum repolist

yum -y install httpd
systemctl start httpd
systemctl enable httpd
cp /vagrant/www/vm.html /var/www/html/index.html
cp /vagrant/www/bodylightweb.bundle.js /var/www/html/
yum -y install chromium

# allow 80 port in firewall
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

# disable selinux, by default enabled, httpd cannot initiate connection otherwise etc.
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 
