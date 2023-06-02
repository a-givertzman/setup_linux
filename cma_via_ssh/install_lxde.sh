#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'         # Blue
RED='\033[0;31m'          # Red


autoStartConfPath='/home/scada/.config/lxsession/LXDE/autostart'
xscreensaverConfPath='/home/scada/.xscreensaver'


insertAfterPattern() {
    pattern=$1
    toInsert=$2
    path=$3
    if [ -z "${pattern}" ] | [ -z "${toInsert}" ] | [ -z "${path}" ]; then
        echo -e "wrong params!"
    else
        # echo -e "\tpattern: $pattern"
        # echo -e "\ttoInsert: $toInsert"
        # echo -e "\tpath: $path"
        sudo awk "!found && /$pattern/ {
            print;
            print \"$toInsert\"; 
            next;
            found=1;
        } 1" $path > /tmp/insertAfterPattern.tmp
        mv /tmp/insertAfterPattern.tmp $path
        echo -e "\tinstalled success!"
    fi
}

setProperty() {
    pattern=$1
    toInsert=$2
    path=$3
    sudo sed -i -r "s/$pattern/$toInsert/1" $path
    if sudo cat $path | grep -E -o "^$toInsert$"; then
        echo -e "\tProperty '$toInsert' already installed into '$path'"
    else
        echo -e "\tProperty '$toInsert' not found in the '$path'"
        echo -e "\t\ttrying to add '$toInsert'"
        echo $toInsert | sudo tee -a $path
        if sudo cat $path | grep -E -o "^$toInsert$"; then
            echo -e "\tProperty '$toInsert' installed into '$path' successful!"
        else
            echo -e "\t${RED}Property '$toInsert' is not installed into '$path'${NC}"
        fi
    fi
}
unsetProperty() {
    pattern=$1
    toInsert=$2
    path=$3
    sudo sed -i -r "s/$pattern/$toInsert/1" $path
    if sudo cat $path | grep -E -o $pattern; then
        echo -e "\t${RED}Can\'t unset '$toInsert' in '$path'${NC}"
    else
        echo -e "\tProperty '$toInsert' unset successful!"
    fi
}

############ Disable xscreensaver ############
echo -e "\t${BLUE}Disabling xscreensaver in "$xscreensaverConfPath"...${NC}"
if [ -f $xscreensaverConfPath ]; then
    pattern='^mode:\s*.*$'
    sed -i -r "s/$pattern/mode:           off/1" $xscreensaverConfPath
    echo -e "\tdone"
else
    # touch $xscreensaverConfPath
    echo 'mode:           off' > $xscreensaverConfPath
    echo -e "\tdone"
fi

############ Configure autostart ############
echo -e "\t${BLUE}Configuring autostart in "$autoStartConfPath"...${NC}"
if [ -f $autoStartConfPath ]; then
    # pattern='^@lxpanel.*$'
    # pattern='^#\s*@lxpanel.*$'
    # sudo sed -i -r "s/$pattern/#@lxpanel --profile LXDE/1" $autoStartConfPath
    unsetProperty '^@lxpanel.*$' '#@lxpanel --profile LXDE' $autoStartConfPath
    # https://launchpad.net/onboard
    setProperty '^#\s*@onboard.*$' '@onboard --keep-aspect' $autoStartConfPath
    dconf write /org/onboard/layout "'/usr/share/onboard/layouts/Small.onboard'"
    dconf write /org/onboard/theme "'Droid'"
    dconf write /org/onboard/auto-show/enabled true
    dconf write /org/onboard/window/force-to-top true

    echo -e "\tdone"
else
    echo -e "\t\t${RED}autostart config not found in: "$autoStartConfPath"${NC}"
    # touch $xscreensaverConfPath
    # echo 'mode:           off' > $autoStartConfPath
fi


############ Configure onboard ############
# sudo yes | cp -rf /tmp/onboard-autostart.desktop /etc/xdg/autostart/onboard-autostart.desktop 

