#!/usr/bin/env bash
set -x
# Prepares VM based on minimal centos 8 installation, with web server, xfce gui, opens ports on firewall
# install apache

#chown -R apache:apache /var/www/html
#chmod -R 644 /var/www/html
#find /var/www/html -type d -exec chmod ugo+rx {} \;
dnf --enablerepo=epel -y install xfce4-panel xfce4-session xfce4-settings xfconf xfdesktop xfwm4 sddm xfce4-terminal
systemctl enable sddm
systemctl start sddm

systemctl set-default graphical.target
# automatic login vagrant
sed -i '/^\[daemon\]/,/^\[security\]/{//!d}' /etc/gdm/custom.conf
sed -i '/\[daemon\]/ aAutomaticLoginEnable=True\n AutomaticLogin=vagrant' /etc/gdm/custom.conf

#yum -y install epel-release
#yum-config-manager --save --setopt=epel/x86_64/metalink.skip_if_unavailable=true
#yum repolist

yum -y install httpd
#httpd-devel required by pip mod_wsgi 

systemctl start httpd
systemctl enable httpd
cat <<EOF >/var/www/html/index.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Bodylight developer web site</title>
    <style>
        div {
            float: left; 
            max-width: 40%;
            min-width:200px;
            border: 1px solid #e1e4e8;
            border-radius: 6px;
            padding: 0.5em;
            margin:0.5em;
            background: #f1f4f8;
        }
        a { color: blue;
        text-decoration:none}
        .small
        {
            color:black;
            font-size:0.6em
        }
    </style>
</head>
<body>

</body>
</html>
EOF

# allow 80 port in firewall
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

# disable selinux, by default enabled, httpd cannot initiate connection otherwise etc.
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config 
