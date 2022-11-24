#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
# echo -e "\n${RED}start from dir: $dirName${NC}"

rebootRemote() {
    echo -e "\nrebooting remote $hostname..."
    ssh -t $username@$hostname 'su -c "systemctl reboot"'
    sleep 5s
    while ! ping -c 1 $hostname &>/dev/null; do :; done
    echo -e "\nreboot remote $hostname done."
}

############ INSTALLETION SETTINGS ############
username=scada
hostname=192.168.120.168

read -p "Enter $username@$hostname password: " sshPassword
read -p "Enter root@$hostname password: " rPassword

install_sudo=false
install_lxde=false
install_autologin=false
install_cma=true
    cma_git_owner='a-givertzman'
    cma_git_repo='crane_monitoring_app'
    cma_git_tag='internal_v0.0.33'
    cma_git_asset='release.zip'
    # cma_git_token='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    cma_git_token='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'
install_api_server=true
install_data_server=true
install_services=true


############ INSTALL SUDO ############
if $install_sudo; then
    sName=install_sudo.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing sudo on remote $hostname...${NC}"
    echo $sshPassword | scp $path $username@$hostname:/tmp/
    echo $sshPassword | ssh -t $username@$hostname "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL LXDE ############
if $install_lxde; then
    sName=install_lxde.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing LXDE on remote $hostname...${NC}"
    echo $sshPassword | scp $path $username@$hostname:/tmp/
    echo $sshPassword | ssh -t $username@$hostname "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL AUTO LOGIN ############
if $install_autologin; then
    sName=install_autologin.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing autologin on remote $hostname...${NC}"
    echo $sshPassword | scp $path $username@$hostname:/tmp/
    echo $sshPassword | ssh -t $username@$hostname "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL CMA ############
if $install_cma; then
    sName=install_cma.sh
    path=$(dirname -- "$0")/$sName
    tmpPath="/tmp/$cma_git_asset"
    echo -e "\n${BLUE}Installing CMA on remote $hostname...${NC}"
    $(dirname -- "$0")/download.sh $cma_git_owner $cma_git_repo $cma_git_tag $cma_git_asset
    echo -e "coping files..."
    echo $sshPassword | scp $path $tmpPath $username@$hostname:/tmp/
    echo -e "instaling application..."
    ssh -t $username@$hostname "chmod +x /tmp/$sName && /tmp/$sName $rPassword $tmpPath"
    rebootRemote
fi

############ INSTALL SERVICES ############
if $install_services; then
    sName=install_services.sh
    path=$(dirname -- "$0")/$sName
    path1=$(dirname -- "$0")/services/api_server.service 
    path2=$(dirname -- "$0")/services/data_server.service
    path3=$(dirname -- "$0")/services/scada_app.service
    echo -e "\n${BLUE}Installing services on remote $hostname...${NC}"
    echo -e "coping files..."
    echo $sshPassword | scp $path $path1 $path2 $path3 $username@$hostname:/tmp/
    echo -e "instaling services..."
    echo $sshPassword | ssh -t $username@$hostname "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
    rebootRemote
fi