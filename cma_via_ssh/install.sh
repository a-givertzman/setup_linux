#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
# echo -e "\n${RED}start from dir: $dirName${NC}"

# ssh -o StrictHostKeyChecking=no -l $username $hostname 'bash -s' < $(dirname -- "$0")/install_autologin.sh
# ssh -o StrictHostKeyChecking=no -l -T $username@$hostname 'sudo su -' < $(dirname -- "$0")/install_autologin.sh
# scripot=$(<$(dirname -- "$0")/install_autologin.sh)
# echo '123qwe' | ssh -tt $username@$hostname "sudo $script"
# ssh -t $username@$hostname "sudo -s && bash" < path

rebootRemote() {
    echo -e "\nrebooting remote $hostname..."
    ssh -t $username@$hostname "sudo reboot"
    sleep 5s
    while ! ping -c 1 $hostname &>/dev/null; do :; done
    echo -e "\nreboot remote $hostname done."
}

############ INSTALLETION SETTINGS ############
username=scada
hostname=192.168.120.157

install_sudo=false
install_autologin=false
install_services=true

############ INSTALL SUDO ############
if $install_sudo; then
    sName=install_autologin.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing autologin on remote $hostname...${NC}"
    scp $path $username@$hostname:/tmp/
    ssh -t $username@$hostname "sudo -s bash /tmp/$sName"
fi

############ INSTALL AUTO LOGIN ############
if $install_autologin; then
    sName=install_autologin.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing autologin on remote $hostname...${NC}"
    scp $path $username@$hostname:/tmp/
    ssh -t $username@$hostname "sudo -s bash /tmp/$sName"
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
    scp $path $path1 $path2 $path3 $username@$hostname:/tmp/
    echo -e "instaling services..."
    ssh -t $username@$hostname "sudo -s bash /tmp/install_services.sh"
    # echo -e "\nrebooting remote $hostname..."
    # ssh -t $username@$hostname "sudo reboot"
    # sleep 5s
    # while ! ping -c 1 $hostname &>/dev/null; do :; done
    # echo -e "\nreboot remote $hostname done."
fi