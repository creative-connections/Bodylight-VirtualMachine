#!/usr/bin/env bash
set -x
echo install and enable mongodb mongodb-server

yum -y install git mongodb mongodb-server
# this is expected to be installed by some previous scripts
#curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
#yum -y remove nodejs
#yum -y install nodejs 
#npm install aurelia-cli -g --quiet
#  systemctl enable httpd
#  systemctl start httpd  
  # allow 80 port in firewall
#  firewall-cmd --zone=public --add-port=80/tcp --permanent
#  firewall-cmd --reload

  # disable selinux, by default enabled, httpd cannot initiate connection otherwise etc.
#  setenforce 0
#  sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

systemctl start mongod
systemctl enable mongod 

echo enable apache psychotest and backend

cat <<EOF > /etc/httpd/conf.d/psychotest.conf
Alias "/psychotest" "/home/vagrant/psychotest-dev/app/dist"
<Directory "/home/vagrant/psychotest-dev/app/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory> 

EOF

cat <<EOF > /etc/httpd/conf.d/psychotestbackend.conf
LoadModule wsgi_module "/home/vagrant/py3/lib64/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so"
WSGIPythonHome "/home/vagrant/py3"
WSGIDaemonProcess psychotest_api user=vagrant group=vagrant processes=1 threads=5 python-home=/home/vagrant/py3 python-path=/home/vagrant/psychotest-dev/backend/pythonevemongodb
WSGIPassAuthorization On
WSGIScriptAlias /api /home/vagrant/psychotest-dev/backend/pythonevemongodb/api.wsgi

<Directory /home/vagrant/psychotest-dev/backend/pythonevemongodb>
    Require all granted
    WSGIProcessGroup psychotest_api
    WSGIApplicationGroup %{GLOBAL}
    Order allow,deny
    Allow from all
</Directory>
EOF

echo putting env variables into /etc/sysconfig/httpd - b2access_client_id, secret can be canged later
PSYCHOTEST_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
cat <<EOF >> /etc/sysconfig/httpd
MONGODB_NAME='psychotestdb'
MONGODB_USR='psychotest'
MONGODB_PWD='psychotest'
B2ACCESS_CLIENT_ID='$B2ACCESS_CLIENT_ID'
B2ACCESS_CLIENT_SECRET='$B2ACCESS_CLIENT_SECRET'
B2ACCESS_API_URL=https://unity.eudat-aai.fz-juelich.de:443/
PSYCHOTEST_SECRET_KEY='$PSYCHOTEST_SECRET'
EOF

echo installing python and virtual env
#alternative Python 3 env
sudo yum -y install python36 python36-devel httpd-devel gcc
#python36-devel httpd-devel and gcc required by pip mod_wsgi
#cd /home/vagrant
#python3 -m venv py3 
#cd 

#service httpd restart moved to user's section bellow

# add reference to index.html
head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/psychotest/"><div><u>Psychotest</u><ul><li><u>/psychotest/</u></li><li class="small">installed at <code>/home/vagrant/psychotest-dev</code></li></ul></div></a>
<a href="/psychotest/editor.html"><div><u>Psychotest Editor</u><ul><li><u>/psychotest/editor.html</u></li></ul></div></a>
</body>
</html>
EOF

echo the rest as vagrant user
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash                                                                                                                                                                                                     
exit $? 
# install psychotest-dev
set -x
cd /home/vagrant
source /vagrant/scripts/bootstrappsychotestenv.sh
#now have GIT_USR and GIT_PWD
git clone https://$GIT_USR:$GIT_TOKEN@github.com/hamu-marc/psychotest-dev.git
cd psychotest-dev/app
npm install
sudo npm install aurelia-cli -g
au build
cd ../..
cd /home/vagrant
python3 -m venv py3 
source /home/vagrant/py3/bin/activate
cd psychotest-dev/backend/pythonevemongodb
mongo admin bootstrapmongo.js
pip install --upgrade pip
pip install -r requirements.txt
sudo service httpd restart
exit 0