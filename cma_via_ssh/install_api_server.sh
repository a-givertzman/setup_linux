#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'         # Blue
RED='\033[0;31m'          # Red

read tmpPath appDir appName <<<$@
echo -e "\tApplication release archive: $tmpPath"
echo -e "\tApplication instalation path: $appDir"
echo -e "\tApplication name: $appName"
# echo -e "\tRoot password: $rPassword"


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
    :
else
    echo -e "\t${BLUE}Installing UnZip on remote $hostname...${NC}"
    su -c 'apt update'
    su -c 'apt install unzip -y'
fi 

echo -e "\t${BLUE}Extracting $tmpPath on remote $hostname...${NC}"
rm -rf '/tmp/release'
unzip $tmpPath -d '/tmp/release/'
extractedDir="$(find /tmp/release -name $appName -type f -printf '%h' -quit)/"
if [ -d "$extractedDir" ]; then
    echo -e "\textracted to "$extractedDir""
    echo -e "\t${BLUE}Coping files on remote $hostname...${NC}"
    rm -rf '/home/scada/app/cma/'
    mkdir -p /home/scada/app
    cp -ra $extractedDir $appDir
    chmod +x "$appDir/$appName"
    echo -e "\tInstalled successful to "$appDir""
else
    echo -e "\textracted not found"
    echo -e "\tNot installed"
fi
