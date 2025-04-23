#!/usr/bin/env bash
set -x

#remove old git if present
# yum -y remove git
# install git 2.x
#yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
#yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.9-1.x86_64.rpm
# wget bzip2 required by emscripten part
yum -y install git wget bzip2     
# nodejs
#curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
#curl -sL https://rpm.nodesource.com/setup_22.x | bash -
#curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum -y remove nodejs
yum -y install nodejs

  cat <<EOF > /etc/httpd/conf.d/bodylight.conf
Alias "/composer" "/home/vagrant/Bodylight.js-Composer/dist/"
<Directory "/home/vagrant/Bodylight.js-Composer/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory>

Alias "/scenarios" "/home/vagrant/Bodylight-Scenarios/"
<Directory "/home/vagrant/Bodylight-Scenarios">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory>

Alias "/virtualbody" "/home/vagrant/Bodylight-VirtualBody/dist/"
<Directory "/home/vagrant/Bodylight-VirtualBody/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory>

Alias "/components" "/home/vagrant/aurelia-bodylight-plugin/docs/"
<Directory "/home/vagrant/aurelia-bodylight-plugin/docs">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

Alias "/webcomponents" "/home/vagrant/Bodylight.js-Components/"
<Directory "/home/vagrant/Bodylight.js-Components">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

Alias "/compiler" "/home/vagrant/Bodylight.js-FMU-Compiler/"
<Directory "/home/vagrant/Bodylight.js-FMU-Compiler">
  Options +ExecCGI
  AddHandler cgi-script .py
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable NameWidth=*
  AllowOverride All
</Directory>

Alias "/editor" "/home/vagrant/Bodylight-Editor/dist/"
<Directory "/home/vagrant/Bodylight-Editor/dist">
  Options +ExecCGI
  AddHandler cgi-script .py
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable NameWidth=*
  AllowOverride All
</Directory>

Alias "/vr" "/home/vagrant/VR/"
<Directory "/home/vagrant/VR">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

Alias "/web" "/home/vagrant/Bodylight-web/dist/"
<Directory "/home/vagrant/Bodylight-web/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

Alias "/homepage" "/home/vagrant/creative-connections.github.io/"
<Directory "/home/vagrant/creative-connections.github.io">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

Alias "/docs" "/home/vagrant/Bodylight-docs/"
<Directory "/home/vagrant/Bodylight-docs">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>


EOF
service httpd reload
echo setting bodylight-compiler service
cat <<EOF >>/etc/systemd/system/bodylight-compiler.service
[Unit]
Description=Bodylight Compiler Service

[Service]
Type=simple
PIDFile=/var/run/bodylight-compiler-service.pid
User=vagrant
ExecStart=/home/vagrant/Bodylight.js-FMU-Compiler/run_local.sh
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=bodylight-compiler
WorkingDirectory=/home/vagrant/Bodylight.js-FMU-Compiler

[Install]
WantedBy=multi-user.target
EOF
#sudo -u vagrant $INSTALLDIR/bin/jupyter notebook --port $3 --no-browser &
# required by bodylight-compiler worker
yum -y install inotify-tools
systemctl enable bodylight-compiler
# systemctl start bodylight-compiler

# install docker - for FMU-Compiler
# yum -y install docker
# systemctl enable docker
# systemctl start docker
# docker replaced by local install of emscripten

# the rest as vagrant
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash
exit $?
# install dev dependencies
sudo npm install aurelia-cli -g
if [ -f "/vagrant/id_rsa" ]; then
  # copy id_rsa to home  
  cp /vagrant/id_rsa /home/vagrant/.ssh/
  cp /vagrant/id_rsa.pub /home/vagrant/.ssh/
  chmod 0400 /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/id_rsa.pub
  # git prefix with git@ 
  GIT_PREFIX=git@github.com:creative-connections
  # copy github.com to known hosts - prevent prompting git clone
  if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null; fi
else
  GIT_PREFIX=https://github.com/creative-connections
fi

# install composer
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight.js-Composer.git
cd Bodylight.js-Composer
git checkout dev-tomas
npm install
au build

# fmu compiler
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight.js-FMU-Compiler.git
cd Bodylight.js-FMU-Compiler
# allow cgi scripts to read/write input and output
chmod ugo+rwx input output
#sudo docker build -t bodylight.js.fmu.compiler "$(pwd)"
# INSTALL emscripten
cd /home/vagrant
# git clone https://github.com/emscripten-core/emsdk.git
wget -q https://github.com/emscripten-core/emsdk/archive/master.zip
unzip master.zip 
cd emsdk-master
./emsdk install latest

# as normal user
# ./emsdk activate latest
#source ./emsdk_env.sh

# install some dependencies
# python3 is already in conda
# cmake
sudo yum -y install cmake
# install GLIBC 2.18
#cd /home/vagrant
#wget -q https://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
#tar -zxvf glibc-2.18.tar.gz
#cd glibc-2.18 && mkdir build
#cd build
# ../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
#make
#sudo make install

sudo systemctl start bodylight-compiler
#mkdir -p /input /output
#chmod ugo+rwx /input /output

# run docker compiler reads from /input - puts to /output
# sudo docker run -d --name bodylight.js.fmu.compiler   -v $(pwd)/input:/input -v $(pwd)/output:/output --rm bodylight.js.fmu.compiler:latest bash worker.sh

# Scenarios
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight-Scenarios.git

# VR
cd /home/vagrant
git clone $GIT_PREFIX/VR.git

# VirtualBody
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight-VirtualBody.git
cd Bodylight-VirtualBody
# cache gltf files used in
mkdir -p static/models
python cachemodels.py
# build 3D Virtualbody app
npm install
au build

# components
#cd /home/vagrant
#git clone $GIT_PREFIX/aurelia-bodylight-plugin.git
#cd aurelia-bodylight-plugin
#npm install
#au build

# webcomponents
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight.js-Components.git
cd Bodylight.js-Components
npm install
au build

# editor
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight-Editor.git
cd Bodylight-Editor
npm install
au build

# docs
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight-docs.git

# bodylight-web
#cd /home/vagrant
#git clone $GIT_PREFIX/Bodylight-web.git
#cd Bodylight-web
#npm install
#au build

# creative github pages
cd /home/vagrant
git clone $GIT_PREFIX/creative-connections.github.io.git

chmod ugo+rx /home/vagrant

exit 0
