#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
# echo -e "\n${RED}start from dir: $dirName${NC}"

# ssh root@MachineB 'bash -s' < local_script.sh

username=scada
hostname=192.168.120.157

# ssh -o StrictHostKeyChecking=no -l $username $hostname 'bash -s' < $(dirname -- "$0")/add_autologin.sh
# ssh -o StrictHostKeyChecking=no -l -T $username@$hostname 'sudo su -' < $(dirname -- "$0")/add_autologin.sh
# scripot=$(<$(dirname -- "$0")/add_autologin.sh)
# echo '123qwe' | ssh -tt $username@$hostname "sudo $script"
# ssh -t $username@$hostname "sudo -s && bash" < path

if false; then
    path=$(dirname -- "$0")/add_autologin.sh 
    echo -e "\n${BLUE}Installing autologin on remote $hostname...${NC}"
    scp $path $username@$hostname:/tmp/
    ssh -t $username@$hostname "sudo -s bash /tmp/add_autologin.sh"
    echo -e "\nrebooting remote $hostname..."
    ssh -t $username@$hostname "sudo reboot"
    sleep 5s
    while ! ping -c 1 $hostname &>/dev/null; do :; done
    echo -e "\nreboot remote $hostname done."
fi

    path=$(dirname -- "$0")/setup_services.sh
    path1=$(dirname -- "$0")/services/api_server.service 
    path2=$(dirname -- "$0")/services/data_server.service
    path3=$(dirname -- "$0")/services/scada_app.service
    echo -e "\n${BLUE}Installing services on remote $hostname...${NC}"
    echo -e "coping files..."
    scp $path $path1 $path2 $path3 $username@$hostname:/tmp/
    echo -e "instaling services..."
    ssh -t $username@$hostname "sudo -s bash /tmp/setup_services.sh"
    echo -e "\nrebooting remote $hostname..."
    ssh -t $username@$hostname "sudo reboot"
    sleep 5s
    while ! ping -c 1 $hostname &>/dev/null; do :; done
    echo -e "\nreboot remote $hostname done."
