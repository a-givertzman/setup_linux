#!/bin/bash

read packages appDir appName <<<$@
echo -e "\tPackeges: $packages"
# echo -e "\tApplication instalation path: $appDir"
# echo -e "\tApplication name: $appName"
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

packageName="tar"
if isInstalled $packageName; then
    :
else
    echo -e "\t${BLUE}Installing tar on remote $hostname...${NC}"
    su -c 'apt update'
    su -c 'apt install tar -y'
fi 


su -c 'apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev -y'

echo -e "\t${BLUE}Extracting $tmpPath on remote $hostname...${NC}"
extractedDir='/tmp/Python-3.10.8'
rm -rf $extractedDir
tar -xvf '/tmp/Python-3.10.8.tgz' --directory '/tmp'
# extractedDir="$(find /tmp/py_release -name $appName -type f -printf '%h' -quit)/"
if [ -d $extractedDir ]; then
    echo -e "\textracted to $extractedDir"
    cd $extractedDir
    ./configure --enable-optimizations
    make -j $(nproc)
    su -c "make altinstall"
    python3.10 --version
    su -c 'apt install python3-pip'
    echo -e "\tInstalled successful to "$appDir""
    python3.10 -m pip install mysql-connector-python
    python3.10 -m pip install numpy
    python3.10 -m pip install python-snap7
else
    echo -e "\textracted not found"
    echo -e "\tNot installed"
fi
