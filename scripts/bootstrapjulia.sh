#!/usr/bin/env bash
set -x

#sudo in case this script is executed after installation
sudo yum install -y wget bzip2
wget --quiet https://julialang-s3.julialang.org/bin/linux/x64/1.3/julia-1.3.0-linux-x86_64.tar.gz -O /home/vagrant/julia.tar.gz
cd /home/vagrant
tar -xzf /home/vagrant/julia.tar.gz
/home/vagrant/julia-1.3.0/bin/julia -e "using Pkg; Pkg.add(\"IJulia\")"
systemctl stop jupyter
systemctl start jupyter