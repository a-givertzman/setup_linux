#!/bin/bash

read rPassword tmpPath <<<$@
echo -e "\tRoot password: $rPassword"
echo -e "\tApplication release archive: $tmpPath"

isInstalled() {
  target=$1
  isInstalledResult=$(dpkg-query -l $target)

  if [[ $isInstalledResult ]]; then
      echo -e "$target is allready installed"
     return 0
  else
      echo -e "$target is not installed"
      return 1
  fi
}

packageName="unzip"
if isInstalled $packageName; then
    echo
else
    echo -e "\n${BLUE}Installing UnZip on remote $hostname...${NC}"
    su -c 'apt update'
    su -c 'apt install unzip -y'
fi 

echo -e "\n${BLUE}Extracting files on remote $hostname...${NC}"
rm -rf '/tmp/release'
unzip $tmpPath -d '/tmp/release/'
echo -e "\n${BLUE}Coping files on remote $hostname...${NC}"
rm -rf '/home/scada/app/cma/'
mkdir -p /home/scada/app
cp -ra "$(find /tmp/release -name crane_monitoring_app -type f -printf '%h' -quit)/" /home/scada/app/cma/
chmod +x '/home/scada/app/cma/crane_monitoring_app'
