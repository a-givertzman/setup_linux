#!/bin/bash

##########################################
# setup proxy configuration
echo -e "${GREEN} Setup proxy configuration?\n0 - no\n1 - yes${RESET}"
read useProxy

if [[ $useProxy == 0  ]]; then
    echo "Continue installing without internet proxy..."
    unset http_proxy https_proxy ftp_proxy rsync_proxy \
          HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
    git config --global --unset http.proxy
elif [[ $useProxy == 1 ]]; then
    echo "trying to configure proxy..."
    echo -e -n "${GREEN}\tproxy server address:${RESET}"
    read proxyIP
    echo -e -n "${GREEN}\tproxy port:${RESET}"
    read proxyPort
    echo -e -n "${GREEN}\tproxy user name:${RESET}"
    read proxyUser
    echo -e -n "${GREEN}\tproxy user pass:${RESET}"
    read proxyPass

    echo "\tconfiguring system proxy..."
    local pre="$proxyUser:$proxyPass@"
    local proxy=$pre$server:$port
    export http_proxy=$proxy
    export https_proxy=$proxy
    export ftp_proxy=$proxy
    export rsync_proxy=$proxy
    export  HTTP_PROXY=$proxy
    export HTTPS_PROXY=$proxy
    export FTP_PROXY=$proxy
    export RSYNC_PROXY=$proxy    

    echo "\tconfiguring git proxy..."
    git config --global http.proxy $proxyUser:$proxyPass@$proxyIP:$proxyPort
else
    echo "Continue installing without internet proxy..."
    # git config --global --unset http.proxy
fi
echo -e "${YELLOW}Current git proxy configuration:${RESET}"
git config --global --get http.proxy