#!/usr/bin/env bash
set -x
# cd to desired directory

DIR=`pwd`
VERSION='jupyter'
if [ ! -d $DIR/$VERSION ]; then
  echo Provisioning Jupyter notebook and dependencies
  if [[ -n "$DIR" ]]
  then
    echo DIR is set to $DIR
  else 
    DIR=$WP6SRC
    echo setting DIR to $DIR
  fi
  if [[ -n "$VERSION" ]]
  then
    echo VERSION is set to $VERSION
  else 
    VERSION=jupyter
    echo setting VERSION to $VERSION
  fi

#sudo in case this script is executed after installation
sudo yum install -y wget bzip2

echo install anaconda gui prerequisities
yum -q -y install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
# anaconda full
if [ ! -f /vagrant/cache/anaconda.sh ]; then
  echo downloading anaconda
  mkdir -p /vagrant/cache/
  wget --quiet https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh -O /vagrant/cache/anaconda.sh
fi
bash /vagrant/cache/anaconda.sh -b -p $DIR/$VERSION

#$DIR/$VERSION/bin/conda activate
source $DIR/$VERSION/bin/activate
# depended gcc c++
yum -y install gcc c++

else
  echo Reusing Jupyter notebook and dependencies installed in $DIR/$VERSION
fi
mkdir /home/vagrant/.jupyter
echo <<EOF > /home/vagrant/.jupyter/jupyter_notebook_config.py
c.NotebookApp.base_url = '/jupyter'
c.NotebookApp.allow_origin_pat='.*'
c.NotebookApp.iopub_data_rate_limit = 1000000000
c.NotebookApp.iopub_msg_rate_limit = 1000000000
c.NotebookApp.token = ''
c.NotebookApp.password = '' 
EOF
head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<a href="/jupyter"><div><u>Jupyter notebook</u> <ul><li> <u>/jupyter</u></li><li class="small">Installed at <code>/home/vagrant/jupyter</code></li></ul></div></a>
</body>
</html>
EOF
