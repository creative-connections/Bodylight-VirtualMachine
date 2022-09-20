#!/usr/bin/env bash
set -x
# Prepares VM with web server, opens ports on firewall
# install apache

#chown -R apache:apache /var/www/html
#chmod -R 644 /var/www/html
#find /var/www/html -type d -exec chmod ugo+rx {} \;

# centos 9 update - epel already in base VM
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
