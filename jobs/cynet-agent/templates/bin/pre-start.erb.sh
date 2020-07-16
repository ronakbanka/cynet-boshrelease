#!/usr/bin/env bash

set -e # exit immediately if a simple command exits with a non-zero status

CynetDirectory="/opt/Cynet/"
CynetPackageDirectory="/var/vcap/packages/cynet-agent/"
AgentBinary="CynetEPS"
DefaultEpsConfig="DefaultEpsConfig.ini"

rootGroup=root
if [ $SUDO_USER ]; then sudoerUser=$SUDO_USER; else sudoerUser=$(/usr/bin/id -run); fi

chmod a+x $CynetPackageDirectory$AgentBinary

echo "Creating folder /opt/Cynet/"
mkdir -p $CynetDirectory
if [ $? -ne 0 ]
then
    echo "error creating folder"
    exit 1;
fi

echo "success,copying $AgentBinary to $CynetDirectory..."
if [[ ! -f $CynetDirectory$AgentBinary ]]; then
  cp -p ${CynetPackageDirectory}$AgentBinary $CynetDirectory$AgentBinary
  if [ $? -ne 0 ]
  then
      echo "error copying cyneteps to folder"
      exit 1;
  fi
fi

echo "success,copying $DefaultEpsConfig to $CynetDirectory..."
if [[ ! -f $CynetDirectory$DefaultEpsConfig ]]; then
  cp ${CynetPackageDirectory}$DefaultEpsConfig $CynetDirectory -p
  if [ $? -ne 0 ]
  then
    echo "error: error copying $DefaultEpsConfig to folder"
    exit 1;
  fi
fi

echo "Adjusting ownership of $CynetDirectory with all the contents to $sudoerUser:$rootGroup"
sudo chown $sudoerUser:$rootGroup $CynetDirectory $CynetDirectory$AgentBinary
if [ $? -ne 0 ]
then
    echo "error adjusting  folder $CynetDirectory and $CynetDirectory$AgentBinary ownership. Continue to next step."
fi

if [ "$HasDefaultConfig" = true ]; then
	echo "Adjusting ownership of $CynetDirectory$DefaultEpsConfig with all the contents to $sudoerUser:$rootGroup"
	sudo chown $sudoerUser:$rootGroup $CynetDirectory$DefaultEpsConfig
	if [ $? -ne 0 ]
	then
		echo "error adjusting $CynetDirectory$DefaultEpsConfig ownership. Continue to next step."
	fi
fi

echo "Successfully done!"
exit 0
