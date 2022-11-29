#!/bin/bash

# echo $0
# echo $1
# echo $2
# arg1=$0; shift
packages=( "$@" )
# read packages <<<$@
# echo -e "\tPackeges: $packages"
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

# su -c 'apt update'
for package in "${packages[@]}"; do 
    package=$(echo $package | sed 's/\s|*\s*/ /g')
    read -r name file url <<< $package
    echo -e "\t${BLUE}$name:${NC}"
    echo -e "\t$file"
    echo -e "\t$url"

    # packageName="tar"
    if isInstalled $name; then
        echo -e "\t${BLUE}$nane already installed on $hostname...${NC}"
    else
        echo -e "\t${BLUE}Installing $name on $hostname...${NC}"
        su -c 'apt install /tmp/$file -y'
    fi 
done
exit 0

# su -c 'apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev -y'

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
