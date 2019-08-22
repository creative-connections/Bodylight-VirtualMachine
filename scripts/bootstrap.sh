#!/usr/bin/env bash

# Prepares VM with web server, opens ports on firewall
# define following variables in order to configure b2note with b2access/google oauth
# install apache

#chown -R apache:apache /var/www/html
#chmod -R 644 /var/www/html
#find /var/www/html -type d -exec chmod ugo+rx {} \;

yum -y install epel-release
yum-config-manager --save --setopt=epel/x86_64/metalink.skip_if_unavailable=true
yum repolist

yum -y install httpd
#mod_wsgi required by b2note_api
#httpd-devel required by pip mod_wsgi 

systemctl start httpd
systemctl enable httpd

# allow 80 port in firewall
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

# disable selinux, by default enabled, httpd cannot initiate connection otherwise etc.
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 
# bootstrap dependencies
#yum -y install dos2unix
#dos2unix /vagrant/scripts/*.sh
#chmod +x /vagrant/scripts/*.sh
#/vagrant/scripts/bootstrapjupyter.sh