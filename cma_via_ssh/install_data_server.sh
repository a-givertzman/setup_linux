#!/bin/bash

read tmpPath appDir appName <<<$@
echo -e "\tApplication release archive: $tmpPath"
echo -e "\tApplication instalation path: $appDir"
echo -e "\tApplication name: $appName"
# echo -e "\tRoot password: $rPassword"


# isInstalled() {
#   target=$1
#   isInstalledResult=$(dpkg-query -l $target)
#   if [[ $isInstalledResult ]]; then
#       echo -e "$target is allready installed"
#      return 0
#   else
#       echo -e "$target is not installed"
#       return 1
#   fi
# }

# packageName="unzip"
# if isInstalled $packageName; then
#     :
# else
#     echo -e "\t${BLUE}Installing UnZip on remote $hostname...${NC}"
#     sudo apt update
#     sudo apt install unzip -y
# fi 

# packageName="mysql-server"
# if isInstalled $packageName; then
#     :
# else
#     echo -e "\t${BLUE}Installing mysql-server on remote $hostname...${NC}"
#     cd /tmp/
#     mySqlPackege="mysql-apt-config_0.8.22-1_all.deb"
#     wget "https://dev.mysql.com/get/$mySqlPackege"
#     sudo dpkg -i $mySqlPackege
#     su -c 'apt update'
#     su -c 'apt-get install mysql-server -y'
# fi 


echo -e "\t${BLUE}Extracting $tmpPath on remote $hostname...${NC}"
rm -rf '/tmp/ds_release'
mkdir '/tmp/ds_release'
tar -xvf $tmpPath --directory '/tmp/ds_release'
# unzip $tmpPath -d '/tmp/ds_release/'
extractedDir="$(find /tmp/ds_release -name $appName -type f -printf '%h' -quit)"
if [ -d "$extractedDir" ]; then
    echo -e "\textracted to "$extractedDir""
    echo -e "\t${BLUE}Coping files on remote $hostname...${NC}"
    rm -rf $appDir
    mkdir -p /home/scada/app
    cp -ra $extractedDir $appDir
    chmod +x "$appDir/$appName"
    echo -e "\tInstalled successful to "$appDir""
else
    echo -e "\textracted not found"
    echo -e "\tNot installed"
fi
