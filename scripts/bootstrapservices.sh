#!/usr/bin/env bash
set -x
yum -q -y install dos2unix
dos2unix /vagrant/scripts/jupyterinapache.sh
/vagrant/scripts/jupyterinapache.sh add vagrant 8901 /jupyter /var/log/jupyter.log
# install pyfmi
# the rest as vagrant
tail -n +$[LINENO+2] $0 | exec sudo -u vagrant bash                                                                                                                                                                                                     
exit $? 
# install pyfmi
/home/vagrant/jupyter/bin/conda install -y -c conda-forge pyfmi
/home/vagrant/julia-1.3.0/bin/julia -e "using Pkg; Pkg.add(\"IJulia\");Pkg.add(\"RDatasets\");Pkg.add(\"Gadfly\")"
systemctl stop jupyter
systemctl start jupyter
exit 0