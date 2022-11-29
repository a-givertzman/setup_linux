#!/bin/bash

# for i in $*; do 
#   echo $i 
# done
packages=("$@")
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
    echo -e "$package:"
    IFS='|' read -r name type file url <<< $package
    echo -e "\ttype: $type:"
    echo -e "\tname: $name:"
    echo -e "\tfile: $file"
    echo -e "\turl: $url"

    if [ $type == apt ]; then
        if isInstalled $name; then
            echo -e "\t${BLUE}$nane already installed on $hostname...${NC}"
        else
            echo -e "\n\t${BLUE}Installing $name on $hostname...${NC}"
            if ! [ -z "${file}" ]; then
                # su -c "dpkg -i /tmp/$file"
                su -c "apt install /tmp/$file -y"
            else
                su -c "apt install $name -y"
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
                extractedDir="/tmp/$name"
                rm -rf $extractedDir
                tar -xvf "/tmp/$file" --directory '/tmp'
                # extractedDir="$(find /tmp/py_release -name $appName -type f -printf '%h' -quit)/"
                if [ -d $extractedDir ]; then
                    echo -e "\textracted to $extractedDir"
                    cd $extractedDir
                    ./configure --enable-optimizations
                    make -j $(nproc)
                    su -c "make altinstall"
                    $name --version
                    su -c 'apt install python3-pip'
                    echo -e "\tInstalled successful to "$appDir""
                else
                    echo -e "\textracted not found"
                    echo -e "\tNot installed"
                fi
            fi
        fi 
    fi
    if [ $type == pip ]; then
        echo -e "\n\t${BLUE}Installing $name on $hostname...${NC}"
        if ! [ -z "${file}" ]; then
            tar -xvf "/tmp/$file" --directory '/tmp/$name'
            python3.10 -m pip install $name --no-index --find-links /tmp/$name/ #file:///srv/pkg/mypackage
        else
            python3.10 -m pip install $name
        fi
    fi
done
