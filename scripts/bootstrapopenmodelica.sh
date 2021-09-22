#!/usr/bin/env bash
set -x
# bootstraps openmodelica and configures it with jupyter nb
# openmodelica, blas-devel and lapack-devel required for OMC, it also installs gcc,c++,c compilers
INSTALLDIR=/home/vagrant/jupyter
wget -q https://build.openmodelica.org/rpm/el7/omc.repo -O /etc/yum.repos.d/omc.repo

# check if local rpm downloaded - install from them otherwise download and install
# OM 1.14 deprecated
# yum install -y yum-plugin-downloadonly
# mkdir -p /vagrant/cache
#if [ ! -f /vagrant/cache/openmodelica-1.14-1.14.1-2.el7.x86_64.rpm ]; then
#  yum install --downloadonly --downloaddir=/vagrant/cache openmodelica-1.14 blas-devel lapack-devel omniORB
#fi 

## OM 1.16
yum -y -q install yum-conf-repos yum-conf-softwarecollections
yum -y -q install devtoolset-8
yum install -y yum-plugin-downloadonly
mkdir -p /vagrant/cache
if [ ! -f /vagrant/cache/openmodelica-1.16* ]; then
  yum install -y --downloadonly --downloaddir=/vagrant/cache openmodelica-nightly-1.18.0~dev~386~g13ce532-1.el7.x86_64 blas-devel lapack-devel omniORB
fi 
#this is installing from local cache downloaded before
yum -y install /vagrant/cache/*.rpm    

# omniorb
#yum install -y omniORB
# zeromq required by ompython and jupyter 
wget -q https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-draft/CentOS_7/network:messaging:zeromq:release-draft.repo -O /etc/yum.repos.d/zeromq.repo
yum install -y zeromq 

# set correct conda environment, bug openmodelica kernel not available
# $INSTALLDIR/bin/conda activate
# pipe the rest of this script via a sudo call, otherwise openmodelica kernel won't be available    

head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<div><u>OpenModelica</u> <br/><ul>
    <li>In Jupyter notebook at <a href="/jupyter/">/jupyter/</a>
    <ul><li>Click <code>New</code></li><li>select <code>OpenModelica</code></li></ul></li>
    <li>Open virtual machine desktop<ul>
    <li>Open terminal emulator and type: </li>
    <li><code>OMEdit</code> - to launch Open Modelica Editor. </li>
    <li><code>omc</code> - to launch Open Modelica Compiler.</li>    
    </ul></li>
</ul></div>
</body>
</html>
EOF
# execute the rest as a user vagrant - need for openmodelica notebook type to be available
chown -R vagrant:vagrant $INSTALLDIR  
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash                                                                                                                                                                                                     
exit $?       
echo integrating jupyter and openmodelica                                                                                                                                                                                                                           
/home/vagrant/jupyter/bin/conda init 
source /home/vagrant/jupyter/bin/activate
# ompython
pip install -q -U https://github.com/OpenModelica/OMPython/archive/master.zip

# jupyter openmodelica nb
pip install -q -U https://github.com/OpenModelica/jupyter-openmodelica/archive/master.zip

# start jupyter with openmodelica ext.
#export INSTALLDIR=$DIR/$VERSION
exit 0
