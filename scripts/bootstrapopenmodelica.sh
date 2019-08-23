#!/usr/bin/env bash
set -x
# bootstraps openmodelica and configures it with jupyter nb
# openmodelica, blas-devel and lapack-devel required for OMC, it also installs gcc,c++,c compilers
INSTALLDIR=/home/vagrant/jupyter
wget https://build.openmodelica.org/rpm/el7/omc.repo -O /etc/yum.repos.d/omc.repo
yum install -y openmodelica-1.13 blas-devel lapack-devel omniORB

# omniorb
#yum install -y omniORB
# zeromq
wget https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-draft/CentOS_7/network:messaging:zeromq:release-draft.repo -O /etc/yum.repos.d/zeromq.repo
yum install -y zeromq 

# set correct conda environment, bug openmodelica kernel not available
# $INSTALLDIR/bin/conda activate
# pipe the rest of this script via a sudo call, otherwise openmodelica kernel won't be available    

head -n -2 /var/www/html/index.html > temp.txt ; mv temp.txt /var/www/html/index.html
cat <<EOF >>/var/www/html/index.html
<h2>OpenModelica</h2>
<p><code>OMEdit</code> - to launch Open Modelica Editor. <code>omc</code> - for om compiler command line script</p>
<p><a href="/jupyter/">/jupyter/</a> - Click <code>New</code> and select <code>OpenModelica</code>.</p>
<p>User's documentation of OpenModelica at <a href="https://openmodelica.org/useresresources/userdocumentation">https://openmodelica.org/useresresources/userdocumentation</a></p>
<hr />
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
