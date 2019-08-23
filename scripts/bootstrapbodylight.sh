#!/usr/bin/env bash
set -x


yum -y install git

# install composer
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-Composer.git
cd Bodylight.js-Composer
cd website
npm install --no-bin-links
npm run build
cd ..
npm install --no-bin-links
npm run prod
cd ..
chown -R vagrant:vagrant /home/vagrant/Bodylight.js-Composer
chmod ugo+rx /home/vagrant
  cat <<EOF > /etc/httpd/conf.d/bodylight.conf
Alias "/composer" "/home/vagrant/Bodylight.js-Composer/build"
<Directory "/home/vagrant/Bodylight.js-Composer/build">
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
<h2>Composer</h2>
<p><a href="/composer/">/composer/</a> - Bodylight.js Composer</p>
<p>External Documentation at <a href="https://github.com/creative-connections/Bodylight.js-Composer"></a></p>
<hr />
</body>
</html>
EOF
# fmu compiler, TODO
cd /home/vagrant
git clone https://github.com/creative-connections/Bodylight.js-FMU-Compiler.git
