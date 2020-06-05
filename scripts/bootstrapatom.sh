#!/usr/bin/env bash
#set -x

wget https://github.com/atom/atom/releases/download/v1.47.0/atom.x86_64.rpm
yum -y install atom.x86_64.rpm
chmod 4755 /usr/share/atom/chrome-sandbox
