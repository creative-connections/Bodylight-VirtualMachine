#!/usr/bin/env bash

HTTPD_CONF="/etc/httpd/conf.d/jupyter.conf"
HTTPD_SERVICE="httpd"
if [ -z "$INSTALLDIR" ]; then 
  echo "INSTALLDIR is not set setting default"
  export INSTALLDIR=/home/vagrant/jupyter
else
  echo using installation at ${INSTALLDIR}
fi

function help {
echo Usage:
echo startJupyter.sh add|remove [username] [port] [proxyurlpart] [logfilepath]
echo   add - adds proxy setting and starts jupyter on port
echo   remove - stops jupyter running on port and removes proxy
echo   [username] is existing VF username with some mounted repositories and existing directory /home/vagrant/work/[username]
echo   [port] the jupyter service will listen in this port
echo   [proxyurlpart] the location, which will be reverse proxied to jupyter service
echo
echo   example:
echo   startJupyter.sh add vagrant 8901 /jupyter /var/log/jupyter.log
echo   startJupyter.sh remove vagrant 8901 /jupyter
}

function addapacheproxy {
  removeapacheproxy $2
  # hostname from the url in argument $1 is ${HOST[2]}, fix bug #24
  WSURL="${1/http/ws}"
  echo $WSURL
  IFS="/:";
  HOSTURL=( $1 )
  HOST=${HOSTURL[2]}
  echo $HOST
  IFS=" ";
  cat <<EOF > $HTTPD_CONF
<Location $2 >
  # RequestHeader set Host \"${HOST}\"
  # on localhost, preservehost leads to ssl proxy error, uncomment if not localhost
  # ProxyPreserveHost On
    ProxyPass $1$2
    ProxyPassReverse $1$2
  </Location>
  <Location $2/api/kernels/>
    ProxyPass $WSURL$2/api/kernels/
    ProxyPassReverse $WSURL$2/api/kernels/
  </Location>
EOF
  # restart needed on SL7? issues reload on cernvm 4
  sudo service ${HTTPD_SERVICE} reload
}

function setjupyterurl {
 url=$1
  #sed -i -e "s/c\.NotebookApp\.base_url.*$/c\.NotebookApp\.base_url = '$1'" /home/vagrant/.jupyter/jupyter_notebook_config.py
 echo setting jupyter url to $url
 #sed -i -e "s|\(c\.NotebookApp\.base\_url\s*=\s*\).*$|\1\'$url\'|g" /home/vagrant/.jupyter/jupyter_notebook_config.py

 cat <<EOF > /home/vagrant/.jupyter/jupyter_notebook_config.py
c.NotebookApp.base_url = '/jupyter'
c.NotebookApp.allow_origin_pat='.*'
c.NotebookApp.iopub_data_rate_limit = 1000000000
c.NotebookApp.iopub_msg_rate_limit = 1000000000
c.NotebookApp.token = ''
c.NotebookApp.password = ''
EOF
  chown -R vagrant:vagrant /home/vagrant/.jupyter
}

function removeapacheproxy {
 if [ -f $HTTPD_CONF ]; then
    rm $HTTPD_CONF
 #L1=`grep -n -m 1 "\<Location $1" $HTTPD_CONF | cut -f1 -d:`
 #if [ "$L1" -gt "0" ]; then
 #  echo removing apache proxy $1
 #  echo from row $L1
 #  let L2=$L1+9
 #  echo to row $L2
 #  sudo sed -i "$L1,$L2 d" $HTTPD_CONF
 #fi
 fi 
}

function removerclocal {
  if grep -Fxq "jupyter" /etc/rc.local
then
    # found remove last row;
    echo found jupyter in rc.local, deleting last row
    sed -i '$ d' /etc/rc.local
else
    # code if not found
    echo jupyter not in rc.local
fi
}

function killjupyter {
echo processes to kill on port $1:
echo ps -ef \| egrep "[p]ort $1"
ps -ef | egrep "[p]ort $1"
PIDS=`ps -ef | egrep "[p]ort $1" | awk '{ print $2 }'`
echo killing jupyter processes $PIDS
kill $PIDS
}

echo startJupyter.sh called with args: $1:$2:$3:$4:$5

if [ -z $2 ]; then
  echo missing username
  help
  exit 1
fi

if [ -z $3 ]; then
  echo missing port
  help
  exit 1
fi

if [ -z $4 ]; then
  echo missing proxyurlpart
  help
  exit 1
fi


if [ $1 == 'remove' ]; then
  killjupyter $3
  removeapacheproxy $4
  #removerclocal
  exit
fi

if [ $1 == 'add' ]; then
  #WORKDIR=/srv/virtualfolder/$2
  #if [ -d $WORKDIR ]; then
  #  echo working directory exists
  #else
  #  echo trying to create working directory, it\'ll be empty
  #  mkdir -p $WORKDIR
  #fi
  #if [ -d $WORKDIR ]; then
  #  cd $WORKDIR
    killjupyter $3
    addapacheproxy http://localhost:$3 $4
    setjupyterurl $4
    if [ -d "/vagrant_data" ]; then 
      cd /vagrant_data
      JUPYTERDIR=/vagrant_data
    else
      cd /vagrant
      JUPYTERDIR=/vagrant
    fi
    JUPYTERPORT=$3
    #chmod ugo+x /etc/rc.local 
    echo launching jupyter
    #source /opt/jupyter/bin/activate py3
    #TODO  removerclocal
    echo adding jupyter to rc.local 
    cat <<EOF >>/etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Service

[Service]
Type=simple
PIDFile=/var/run/jupyter-service.pid
User=vagrant
ExecStart=/home/vagrant/jupyter/bin/jupyter notebook --port ${JUPYTERPORT} --no-browser
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=westlife-metadata
WorkingDirectory=${JUPYTERDIR}

[Install]
WantedBy=multi-user.target
EOF
    #sudo -u vagrant $INSTALLDIR/bin/jupyter notebook --port $3 --no-browser &
    systemctl enable jupyter
    systemctl start jupyter
  exit
  #else
  #  echo Directory $WORKDIR does not exist.
  #  help
  #  exit 1
  #fi
fi

help
exit 1
