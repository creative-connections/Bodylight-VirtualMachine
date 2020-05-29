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

Alias "/components" "/home/vagrant/Bodylight.js-Components/webcomponents/dist/"
<Directory "/home/vagrant/Bodylight.js-Components/webcomponents/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options +Indexes +FollowSymLinks +IncludesNOEXEC
  IndexOptions FancyIndexing HTMLTable
  AllowOverride All
</Directory>

EOF
service httpd reload

# add reference to index.html
head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/composer/"><div><u>Bodylight.js Composer</u><ul><li><u>/composer/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Composer</code></li></ul></div></a>
<a href="/virtualbody/"><div><u>Virtual Body App</u><ul><li><u>/virtualbody/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
<a href="/components/"><div><u>Web Components</u><ul><li><u>/components/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Components</code></li></ul></div></a>
<a href="/scenarios/"><div><u>Scenarios</u><ul><li><u>/scenarios/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
</body>
</html>
EOF

# install docker - for FMU-Compiler
yum -y install docker
systemctl enable docker
systemctl start docker

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

# fmu compiler, TODO
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-FMU-Compiler.git
cd Bodylight.js-FMU-Compiler
sudo docker build -t bodylight.js.fmu.compiler "$(pwd)"
# run docker compiler reads from /input - puts to /output
sudo docker run -d   --name bodylight.js.fmu.compiler   -v /input:$(pwd)/input -v /output:$(pwd)/output  --rm bodylight.js.fmu.compiler:latest bash worker.sh


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
git clone https://github.com/creative-connections/Bodylight.js-Components.git
cd Bodylight.js-Components/webcomponents/
# git checkout dev-tomas
# build components app
npm install
au build

chmod ugo+rx /home/vagrant

exit 0
