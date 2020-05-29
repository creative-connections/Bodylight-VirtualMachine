#!/usr/bin/env bash
#set -x

#sudo in case this script is executed after installation
sudo yum install -y wget bzip2
mkdir -p /vagrant/cache
if [ ! -f /vagrant/cache/julia.tar.gz ]; then
  echo downloading julia
  wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/1.3/julia-1.3.0-linux-x86_64.tar.gz -O /vagrant/cache/julia.tar.gz
fi
cd /home/vagrant
tar -xzf /vagrant/cache/julia.tar.gz
#install julia depended packages in bootstrapservices