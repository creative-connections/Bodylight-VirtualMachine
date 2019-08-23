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
cat <<EOF >/var/www/html/index.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Bodylight developer web site</title>
</head>
<body>
<h1>List of installed application.</h1>
<h2>Apache server</h2>
<p>Inside VM you can view using http://localhost. Outside vm, port forwarding needs to be set up, by default to 8080, use http://localhost:8080</p>
<p>To start use <code>systemctl start httpd</code>.To stop use <code>systemctl stop httpd</code>.</p>
<hr />
</body>
</html>
EOF

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