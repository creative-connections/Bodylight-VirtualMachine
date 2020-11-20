#!/usr/bin/env bash
set -x

yum -y install git
# nodejs
#curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
curl -sL https://rpm.nodesource.com/setup_14.x | bash -
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



# add reference to index.html
head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/composer/"><div><u>Bodylight.js Composer</u><ul><li><u>/composer/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Composer</code></li></ul></div></a>
<a href="/virtualbody/"><div><u>Virtual Body App</u><ul><li><u>/virtualbody/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
<a href="/components/"><div><u>Web Components</u><ul><li><u>/components/</u></li><li class="small">installed at <code>/home/vagrant/aurelia-bodylight-plugin</code></li></ul></div></a>
<a href="/webcomponents/"><div><u>Web Components Demo</u><ul><li><u>/webcomponents/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Components</code></li></ul></div></a>
<a href="/scenarios/"><div><u>Scenarios</u><ul><li><u>/scenarios/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
<a href="/compiler/"><div><u>Bodylight.js Compiler</u><ul><li><u>/compiler/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-FMU-Compiler</code></li></ul></div></a>
<a href="/editor/"><div><u>Bodylight Editor</u><ul><li><u>/editor/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Editor</code></li></ul></div></a>

</body>
</html>
EOF

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

# install composer
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-Composer.git
cd Bodylight.js-Composer
git checkout dev-tomas
npm install
au build

# fmu compiler
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-FMU-Compiler.git
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
yum -y install cmake
# install GLIBC 2.18
cd /home/vagrant
wget -q https://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
tar -zxvf glibc-2.18.tar.gz
cd glibc-2.18 && mkdir build
cd build
../configure --prefix=/usr --disable-profile --enable-add-ons --with-headers=/usr/include --with-binutils=/usr/bin
make
sudo make install

sudo systemctl start bodylight-compiler
#mkdir -p /input /output
#chmod ugo+rwx /input /output

# run docker compiler reads from /input - puts to /output
# sudo docker run -d --name bodylight.js.fmu.compiler   -v $(pwd)/input:/input -v $(pwd)/output:/output --rm bodylight.js.fmu.compiler:latest bash worker.sh

# Scenarios
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight-Scenarios.git

# VirtualBody
git clone https://github.com/creative-connections/Bodylight-VirtualBody.git
cd Bodylight-VirtualBody
# cache gltf files used in
mkdir -p static/models
python cachemodels.py
# build 3D Virtualbody app
npm install
au build

# components
cd /home/vagrant
git clone https://github.com/creative-connections/aurelia-bodylight-plugin.git
cd aurelia-bodylight-plugin
npm install
au build

# webcomponents
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-Components.git
cd Bodylight.js-Components
npm install
au build

# editor
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight-Editor.git
cd Bodylight-Editor
npm install
au build

chmod ugo+rx /home/vagrant

exit 0
