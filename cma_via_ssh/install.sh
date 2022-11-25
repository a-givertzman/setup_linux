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
installLxde=true
installAutologin=false
installCma=true
    cmaAppDir='/home/scada/app/cma/'
    cmaAppName='crane_monitoring_app'
    cmaGitOwner='a-givertzman'
    cmaGitRepo='crane_monitoring_app'
    cmaGitTag='internal_v0.0.33'
    cmaGitAsset='release.zip'
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    cmaGitToken='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'
installApiServer=true
installDataServer=true
installServices=true



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