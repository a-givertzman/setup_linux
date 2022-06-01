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
    proxyIP="${GREEN}\tproxy server:${RESET}"
    proxyPort="${GREEN}\tproxy port:${RESET}> "
    proxyUser="${GREEN}\tproxy user name:${RESET}> "
    proxyPass="${GREEN}\tproxy user pass:${RESET}> "
    git config --global http.proxy $proxyUser:$proxyPass@$proxyIP:$proxyPort
else
    echo "Continue installing without internet proxy..."
    # git config --global --unset http.proxy
fi
