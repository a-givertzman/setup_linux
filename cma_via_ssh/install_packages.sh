#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'         # Blue
RED='\033[0;31m'          # Red

sudoPass=${1/null/}
proxySet=${2/null/}
reserve=${3/null/}
shift; shift; shift
# packages=("$@")
echo -e "\tSudo pass: $sudoPass"
echo -e "\tProxy: $proxySet"
echo -e "\tReserve: $reserve"
# echo -e "\tPackeges: "
# for i in $*; do 
#   echo -e "\t\t$i" 
# done


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

# sudo export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
sudo echo "PATH: $PATH"
sudo apt update
for package in $*; do 
    echo -e "$package:"
    IFS='|' read -r name type url file extracted <<< $package
    echo -e "\ttype: $type"
    echo -e "\tname: $name"
    echo -e "\tfile: $file"
    echo -e "\turl: $url"

    if [ $type == apt ]; then
        if isInstalled $name; then
            echo -e "\t${BLUE}$nane already installed on $hostname...${NC}"
        else
            echo -e "\n\t${BLUE}Installing $name on $hostname...${NC}"
            if ! [ -z "${file}" ]; then
                if ! [[ $file == *.deb ]]; then
                    echo -e "\t${BLUE}Extracting /tmp/$file on remote $hostname...${NC}"
                    tar -xvf "/tmp/$file" --directory '/tmp'
                    file=$extracted
                fi
                sudo apt install /tmp/$file -y
            else
                sudo apt install $name -y
            fi
        fi 
    fi
    if [ $type == apt-conf ]; then
        if isInstalled $name; then
            echo -e "\t${BLUE}$nane already installed on $hostname...${NC}"
        else
            echo -e "\n\t${BLUE}Installing apt coniguration for $name on $hostname...${NC}"
            if ! [ -z "${file}" ]; then
                if ! [[ $file == *.deb ]]; then
                    echo -e "\t${BLUE}Extracting /tmp/$file on remote $hostname...${NC}"
                    tar -xvf "/tmp/$file" --directory '/tmp'
                    file=$extracted
                fi
                sudo dpkg -i /tmp/$file && sudo apt update
            fi
        fi 
    fi
    if [ $type == src ]; then
        if isInstalled $name; then
            echo -e "\t${BLUE}$nane already installed on $hostname...${NC}"
        else
            echo -e "\n\t${BLUE}Installing $name on $hostname...${NC}"
            if ! [ -z "${file}" ]; then
                echo -e "\t${BLUE}Extracting /tmp/$file on remote $hostname...${NC}"
                rm -rf $/tmp/$extracted
                tar -xvf "/tmp/$file" --directory '/tmp'
                # extractedDir="$(find /tmp/py_release -name $appName -type f -printf '%h' -quit)/"
                if [ -d /tmp/$extracted ]; then
                    echo -e "\textracted to /tmp/$extracted"
                    cd /tmp/$extracted
                    ./configure --enable-optimizations --with-lto --with-ensurepip
                    make -j $(nproc)
                    sudo make altinstall
                    $name --version
                    echo -e "\tInstalled successful"
                else
                    echo -e "\textracted not found on "/tmp/$extracted""
                    echo -e "\tNot installed"
                fi
            fi
        fi 
    fi
    if [ $type == pip ]; then
        echo -e "\n\t${BLUE}Installing $name on $hostname...${NC}"
        if ! [ -z "${file}" ]; then
            # tar -xvf "/tmp/$file" --directory '/tmp/$name'
            # python3.10 -m pip install -e /tmp/$file
            # python3.10 -m pip install /tmp/$file
            python3.10 -m pip install $name --no-index --find-links /tmp/$file
        else
            python3.10 -m pip install \
                ${proxySet:+ --proxy "${proxySet}"} \
                $name
        fi
    fi
done
