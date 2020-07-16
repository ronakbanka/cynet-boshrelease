#!/usr/bin/env bash

set -e # exit immediately if a simple command exits with a non-zero status

CynetDirectory="/opt/Cynet/"
CynetPackageDirectory="/var/vcap/packages/cynet-agent/"
file="CynetEPS"
file4="DefaultEpsConfig.ini"

rootGroup=root
if [ $SUDO_USER ]; then sudoerUser=$SUDO_USER; else sudoerUser=$(/usr/bin/id -run); fi

chmod a+x $CynetPackageDirectory$file

echo "Creating folder /opt/Cynet/"
mkdir -p $CynetDirectory
if [ $? -ne 0 ]
then
    echo "error creating folder"
    exit 1;
fi

echo "success,copying $file to $CynetDirectory..."
if [[ ! -f $CynetDirectory$file ]]; then
  cp -p ${CynetPackageDirectory}$file $CynetDirectory$file
  if [ $? -ne 0 ]
  then
      echo "error copying cyneteps to folder"
      exit 1;
  fi
fi

echo "success,copying $file4 to $CynetDirectory..."
if [[ ! -f $CynetDirectory$file4 ]]; then
  cp ${CynetPackageDirectory}$file4 $CynetDirectory -p
  if [ $? -ne 0 ]
  then
    echo "error: error copying $file4 to folder"
    exit 1;
  fi
fi

echo "Adjusting ownership of $CynetDirectory with all the contents to $sudoerUser:$rootGroup"
sudo chown $sudoerUser:$rootGroup $CynetDirectory $CynetDirectory$file
if [ $? -ne 0 ]
then
    echo "error adjusting  folder $CynetDirectory and $CynetDirectory$file ownership. Continue to next step."
fi

if [ "$HasDefaultConfig" = true ]; then
	echo "Adjusting ownership of $CynetDirectory$file4 with all the contents to $sudoerUser:$rootGroup"
	sudo chown $sudoerUser:$rootGroup $CynetDirectory$file4
	if [ $? -ne 0 ]
	then
		echo "error adjusting $CynetDirectory$file4 ownership. Continue to next step."
	fi
fi

echo "Successfully done!"
exit 0
