#!/usr/bin/env bash
echo testing
set -e

# test apache is running
if [ $(service httpd status | grep '(running)' | wc -l) > 0 ]
then
 echo "Apache is running."
 APACHE=0
else
 echo "Apache is not running."
 APACHE=1
fi

# test endpoints
responsej=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost/jupyter/)
if [[ $responsej == 302 ]]; then 
  JUPYTER=0
else
  JUPYTER=1
fi

responsev=$(curl --write-out %{http_code} --silent --output /dev/null http://localhost/virtualbody/)
if [[ $responsev == 200 ]]; then 
  VBODY=0
else
  VBODY=1
fi

# test OMC
OMEDIT=0
OMC=0
hash OMEdit 2>/dev/null || { echo >&2 "OMEdit not installed.  "; OMEDIT=1; }
hash omc 2>/dev/null || { echo >&2 "omc not installed.  "; OMC=1; }

exit $(($APACHE+$JUPYTER+$VBODY+$OMEDIT+$OMC))