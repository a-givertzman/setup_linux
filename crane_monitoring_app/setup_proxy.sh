#!/bin/bash

##########################################
# setup proxy configuration
echo -e "${GREEN} Setup proxy configuration?\n0 - no\n1 - yes${RESET}"
read useProxy

if [[ $useProxy == 0  ]]; then
    echo "Continue installing without internet proxy..."
    git config --global --unset http.proxy
elif [[ $useProxy == 1 ]]; then
    echo "trying to configure proxy..."
    echo -e "${GREEN}\tproxy server address:${RESET}"
    read proxyIP
    echo -e "${GREEN}\tproxy port:${RESET}"
    read proxyPort
    echo -e "${GREEN}\tproxy user name:${RESET}"
    read proxyUser
    echo -e "${GREEN}\tproxy user pass:${RESET}"
    read proxyPass
    git config --global http.proxy $proxyUser:$proxyPass@$proxyIP:$proxyPort
else
    echo "Continue installing without internet proxy..."
    # git config --global --unset http.proxy
fi
