#!/usr/bin/env bash
set -x
yum -q -y install dos2unix
dos2unix /vagrant/scripts/jupyterinapache.sh
/vagrant/scripts/jupyterinapache.sh add vagrant 8901 /jupyter /var/log/jupyter.log
