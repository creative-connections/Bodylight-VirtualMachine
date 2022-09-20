#!/usr/bin/env bash
set -x
# omniorb
#yum install -y omniORB
# zeromq required by ompython and jupyter 
wget -q https://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-draft/CentOS_7/network:messaging:zeromq:release-draft.repo -O /etc/yum.repos.d/zeromq.repo
yum install -y zeromq 

# set correct conda environment, bug openmodelica kernel not available
# $INSTALLDIR/bin/conda activate
# pipe the rest of this script via a sudo call, otherwise openmodelica kernel won't be available    

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
