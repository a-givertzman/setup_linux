#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'         # Blue
RED='\033[0;31m'          # Red

sudoPass=${1/null/}
proxySet=${2/null/}
sqlPath=${3/null/}
shift; shift; shift
# packages=("$@")
echo -e "\tSudo pass: $sudoPass"
echo -e "\tProxy: $proxySet"
echo -e "\tsqlPath: $sqlPath"
# echo -e "\tPackeges: "
# for i in $*; do 
#   echo -e "\t\t$i" 
# done

sudo mysql -u root -p < /tmp/$sqlPath
