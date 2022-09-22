#!/usr/bin/env bash
set -x
# bootstraps openmodelica and configures it with jupyter nb
# openmodelica, blas-devel and lapack-devel required for OMC, it also installs gcc,c++,c compilers
INSTALLDIR=/home/vagrant/jupyter
#wget -q http://mirror.stream.centos.org/9-stream/CRB/x86_64/os/media.repo -O /etc/yum.repos.d/media.repo
# check if local rpm downloaded - install from them otherwise download and install
# OM 1.14 deprecated
# yum install -y yum-plugin-downloadonly
# mkdir -p /vagrant/cache
#if [ ! -f /vagrant/cache/openmodelica-1.14-1.14.1-2.el7.x86_64.rpm ]; then
#  yum install --downloadonly --downloaddir=/vagrant/cache openmodelica-1.14 blas-devel lapack-devel omniORB
#fi 

## OM 1.16
#yum -y install yum-conf-repos yum-conf-softwarecollections
#yum -y install devtoolset-8

# enable CRB repository to install dev tools
yum -y install yum-utils
yum-config-manager --enable crb
yum -y install gcc-toolset-12

# yum -y install lapack-static openblas-static blas-static
# yum install -y yum-plugin-downloadonly
# mkdir -p /vagrant/cache
# if [ ! -f /vagrant/cache/openmodelica* ]; then
#  yum install -y --downloadonly --downloaddir=/vagrant/cache openmodelica-nightly blas-devel lapack-devel lapack-static openblas-static omlib-none 
  # blas-static omniORB
# fi 

#this is installing from local cache downloaded before
# yum -y install /vagrant/cache/*.rpm    

yum install -y blas-devel lapack-devel lapack-static openblas-static
# EL9 builds in progress uncomment when done - see status at https://build.openmodelica.org/rpm/el9/ and https://test.openmodelica.org/jenkins/blue/organizations/jenkins/LINUX_BUILDS/activity
# wget -q https://build.openmodelica.org/rpm/el9/omc.repo -O /etc/yum.repos.d/omc.repo
# yum install -y openmodelica-nightly 