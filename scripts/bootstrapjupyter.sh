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

## install from Miniconda
#mkdir -p $DIR
#cd $DIR
#if [ ! -f Miniconda3-latest-Linux-x86_64.sh ]; then
#  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
#  chmod +x Miniconda3-latest-Linux-x86_64.sh
#fi
#$DIR/Miniconda3-latest-Linux-x86_64.sh -b -p $DIR/$VERSION
#$DIR/$VERSION/bin/conda create -y --name py3 python=3
#source $DIR/$VERSION/bin/activate py3
#conda install -y -c rdkit -c bioconda rdkit jupyter pymc3 r-irkernel r=3.3.2 tornado=4.5.3 scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 pivottablejs jupyterlab python-libsbml cobra xmltodict 
#conda install -y -c InsiliChem  prody
#conda install -y -c conda-forge -c bioconda bioservices jupyter_contrib_nbextensions nglview octave octave_kernel ghostscript texinfo bqplot mpld3 ipython-sql
#conda install -y -c rdkit rdkit
# machine learning course
#conda install -y scikit-learn seaborn keras mkl pandas pillow pydot scipy tensorflow 
# data science handbook
#conda install -y scikit-image line_profiler memory_profiler numexpr pandas-datareader netcdf4 
# jupyter tips and tricks
#conda install -y pivottablejs jupyterlab
# octave
# conda install -q -y -c conda-forge octave octave_kernel ghostscript texinfo

##commented as it seems to take too long to install
##conda install -y -c conda-forge bqplot mpld3 ipython-sql
#jupyter-nbextension enable nglview --py --sys-prefix

echo install anaconda gui prerequisities
yum -q -y install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
# anaconda full
if [ ! -f /vagrant/cache/anaconda.sh ]; then
  echo downloading anaconda
  wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O /vagrant/cache/anaconda.sh
fi
bash /vagrant/cache/anaconda.sh -b -p $DIR/$VERSION

#$DIR/$VERSION/bin/conda activate
source $DIR/$VERSION/bin/activate
# depended gcc c++
yum -y install gcc c++
# nodejs
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum -y remove nodejs
yum -y install nodejs 
# jupyter prov-o ssbio sos polyglot notebook
# pip install -q prov ssbio sos sos-notebook sos-r
# python -m sos_notebook.install
# jupyter labextension install jupyterlab-sos

#link to jupyter installation
#ln -s $DIR/$VERSION /opt/jupyter
#DIR_ESC=$(echo $DIR/$VERSION | sed 's_/_\\/_g')
#sed -i -e "s/\/cvmfs\/west-life.egi.eu\/software\/jupyter\/latest/$DIR_ESC/g" $WP6SRC/scripts/startJupyter.sh
#sed -i -e "s/\/cvmfs\/west-life.egi.eu\/software\/jupyter\/latest/$DIR_ESC/g" $WP6SRC/scripts/startJupyterlab.sh
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
# move start after openmodelica is installed
# /vagrant/scripts/jupyterinapache.sh add vagrant 8901 /jupyter /var/log/jupyter.log



