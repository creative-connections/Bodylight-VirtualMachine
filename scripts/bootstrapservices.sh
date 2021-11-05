#!/usr/bin/env bash
#set -x
yum -q -y install dos2unix zip unzip
dos2unix /vagrant/scripts/jupyterinapache.sh
bash /vagrant/scripts/jupyterinapache.sh add vagrant 8901 /jupyter /var/log/jupyter.log
# install pyfmi
# the rest as vagrant
chown -R vagrant:vagrant /home/vagrant
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash                                                                                                                                                                                                     
exit $? 
set -x 
# install pyfmi and mamba
/home/vagrant/jupyter/bin/conda init
/home/vagrant/jupyter/bin/conda install -q -y -c conda-forge fmpy psutil
# SOS notebooks - deprecating
# n=0
# until [ $n -ge 5 ]
# do
#   echo "attempting to do mamba install "$n
#   /home/vagrant/jupyter/bin/mamba install -q -y -c conda-forge sos sos-pbs sos-notebook jupyterlab-sos sos-bash sos-python && break  # substitute your command here
#   n=$[$n+1]
#   sleep 2
# done
# SALib for sensitivity analysis, DyMat for opening Modelica MAT files in Python
/home/vagrant/jupyter/bin/pip install -q DyMat SALib 
sudo systemctl stop jupyter
sudo systemctl start jupyter
sudo systemctl start httpd
echo "Bootstrap finished, VM should be created and ready. See web http://localhost:8080/ for further info."
exit 0
