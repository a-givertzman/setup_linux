#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
# echo -e "\n${RED}start from dir: $dirName${NC}"

isInstalled() {
  target=$1
  isInstalledResult=$(dpkg-query -l $target)
  if [[ $isInstalledResult ]]; then
  # if dpkg-query -l xinit; then
    #   echo -e "$target is allready installed"
    return 0
  else
    #   echo -e "$target is not installed"
    return 1
  fi
}

installPackage() {
    packageName=$1
    if isInstalled $packageName; then
        echo -e "$packageName already installed"
    else
        echo -e "installing $packageName..."
        sudo apt install $packageName
    fi 
}

rebootRemote() {
    echo -e "\nrebooting remote $hostName..."
    ssh -t $userName@$hostName 'su -c "systemctl reboot"'
    sleep 5s
    while ! ping -c 1 $hostName &>/dev/null; do :; done
    echo -e "\nreboot remote $hostName done."
}

############ INSTALLING DEPENDENCIES ON LOCAL ############
# installPackage sshpass


############ INSTALLETION SETTINGS ############
userName=scada
hostName=192.168.120.168

installSudo=false
installLxde=false
installAutologin=false
installPython310=true
    py310Url='https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz'
    py310Asset='Python-3.10.8.tgz'
installCma=false
    cmaAppDir='/home/scada/app/cma/'
    cmaAppName='crane_monitoring_app'
    cmaGitOwner='a-givertzman'
    cmaGitRepo='crane_monitoring_app'
    cmaGitTag='internal_v0.0.33'
    cmaGitAsset='release.zip'
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    cmaGitToken='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'
# installApiServer=false
installDataServer=false
    dsAppDir='/home/scada/app/data_server/'
    dsAppName='sds_run.py'
    dsGitOwner='a-givertzman'
    dsGitRepo='s7-data-server'
    dsGitBranch='Fault-Registrator'
    dsGitAsset='ds_release.zip'
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    dsGitToken='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'
installServices=false

# proxy_set="http://constr:constr@192.168.120.234:3128"
# GITHUB_API_TOKEN=$dsGitToken
# CURL_ARGS="-LJ"

# owner=$dsGitOwner
# repo=$dsGitRepo
# tag=$dsGitTag
# GH_API="https://api.github.com"
# GH_REPO="$GH_API/repos/$owner/$repo"
# GH_TAGS="$GH_REPO/releases/tags/$tag"
# GH_ASSET="$GH_REPO/releases/assets/"
# GH_ASSET="$GH_REPO/releases/tags/$tag"

# target=$dirName/distro/ds_src.zip

# echo "url: $GH_ASSET"
# echo "target: $target"

# curl $CURL_ARGS \
#     --progress-bar \
#     --proxy $proxy_set \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/json' \
#     "$GH_ASSET" > $target
# curl $CURL_ARGS \
#     --progress-bar \
#     --proxy $proxy_set \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/vnd.github+json' \
#     "https://api.github.com/repos/a-givertzman/s7-data-server/zipball/Fault-Registrator" > $target


#     # -H 'Accept: application/octet-stream' \
#     # -H 'Accept: application/json' \
# exit 0


# read -p "Enter $userName@$hostName password: " sshPassword
# read -p "Enter root@$hostName password: " rPassword


############ INSTALL SUDO ############
if $installSudo; then
    sName=install_sudo.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing sudo on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL LXDE ############
if $installLxde; then
    sName=install_lxde.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing LXDE on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL LXDE AUTO LOGIN ############
if $installAutologin | $installLxde; then
    sName=install_autologin.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing LXDE autologin on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL PYTHON3.10 ############
if $installPython; then
    sName=install_python310.sh
    path=$(dirname -- "$0")/$sName
    tmpPath=$(dirname -- "$0")/distro/$py310Asset
    echo -e "\n${BLUE}Installing python3.10 on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        curl $py310Url > $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$cmaGitAsset $cmaAppDir $cmaAppName"
fi

############ INSTALL DATA SERVER ############
if $installDataServer; then
    sName=install_data_server.sh
    path=$(dirname -- "$0")/$sName
    tmpPath=$(dirname -- "$0")/distro/$dsGitAsset
    echo -e "\n${BLUE}Installing DATA SERVER on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        $(dirname -- "$0")/download_src.sh $dsGitOwner $dsGitRepo $dsGitBranch $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$dsGitAsset $dsAppDir $dsAppName"
fi

############ INSTALL CMA ############
if $installCma; then
    sName=install_cma.sh
    path=$(dirname -- "$0")/$sName
    tmpPath=$(dirname -- "$0")/distro/$cmaGitAsset
    echo -e "\n${BLUE}Installing CMA on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        $(dirname -- "$0")/download.sh $cmaGitOwner $cmaGitRepo $cmaGitTag $cmaGitAsset $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$cmaGitAsset $cmaAppDir $cmaAppName"
fi

############ INSTALL SERVICES ############
if $installServices; then
    sName=install_services.sh
    path=$(dirname -- "$0")/$sName
    path1=$(dirname -- "$0")/services/api_server.service 
    path2=$(dirname -- "$0")/services/data_server.service
    path3=$(dirname -- "$0")/services/scada_app.service
    path4=$(dirname -- "$0")/services/configure_ui.service
    path5=$(dirname -- "$0")/configure_ui.sh
    echo -e "\n${BLUE}Installing services on remote $hostName...${NC}"
    echo -e "coping files..."
    scp $path $path1 $path2 $path3 $path4 $path5 $userName@$hostName:/tmp/
    echo -e "instaling services..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && su -c'/tmp/$sName'"
    rebootRemote
fi