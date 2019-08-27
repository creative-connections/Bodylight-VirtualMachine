#!/usr/bin/env bash
set -x


yum -y install git

  cat <<EOF > /etc/httpd/conf.d/bodylight.conf
Alias "/composer" "/home/vagrant/Bodylight.js-Composer/build"
<Directory "/home/vagrant/Bodylight.js-Composer/build">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory> 

Alias "/virtualbody" "/home/vagrant/Bodylight-Scenarios/virtualpatientapp/dist"
<Directory "/home/vagrant/Bodylight-Scenarios/virtualpatientapp/dist">
  Header set Access-Control-Allow-Origin "*"
  Require all granted
  Options FollowSymLinks IncludesNOEXEC
  AllowOverride All
</Directory>

EOF
service httpd reload

# add reference to index.html
head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/composer/"><div><u>Bodylight.js Composer</u><ul><li><u>/composer/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight.js-Composer</code></li></ul></div></a>
<a href="/virtualbody/"><div><u>Virtual Body App</u><ul><li><u>/virtualbody/</u></li><li class="small">installed at <code>/home/vagrant/Bodylight-Scenarios</code></li></ul></div></a>
</body>
</html>
EOF

# the rest as vagrant
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash                                                                                                                                                                                                     
exit $? 
# install composer
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-Composer.git
cd Bodylight.js-Composer
cd website
npm install
npm run build
cd ..
npm install 
npm install webpack
npm run prod
cd ..
#chown -R vagrant:vagrant /home/vagrant/Bodylight.js-Composer
chmod ugo+rx /home/vagrant
# fmu compiler, TODO
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-FMU-Compiler.git
git clone https://github.com/creative-connections/Bodylight-Scenarios.git

exit 0