#!/usr/bin/env bash
set -x

if [ -f "/vagrant/id_rsa" ]; then
  # copy id_rsa to home  
  cp /vagrant/id_rsa /home/vagrant/.ssh/
  cp /vagrant/id_rsa.pub /home/vagrant/.ssh/
  chmod 0400 /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/id_rsa.pub
  # git prefix with git@ 
  GIT_PREFIX=git@github.com:creative-connections
  # copy github.com to known hosts - prevent prompting git clone
  if [ ! -n "$(grep "^github.com " ~/.ssh/known_hosts)" ]; then ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null; fi
else
  GIT_PREFIX=https://github.com/creative-connections
fi

echo $GIT_PREFIX

# install composer
cd /home/vagrant
git clone $GIT_PREFIX/Bodylight.js-Composer.git
git clone $GIT_PREFIX/Bodylight-Scenarios.git
git clone $GIT_PREFIX/Bodylight-Editor.git

chmod ugo+rx /home/vagrant

exit 0
