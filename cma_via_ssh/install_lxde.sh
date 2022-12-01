#!/bin/bash

NC='\033[0m'
BLUE='\033[0;34m'         # Blue
RED='\033[0;31m'          # Red


autoStartConfPath='/etc/xdg/lxsession/LXDE/autostart'
xscreensaverConfPath='/home/scada/.xscreensaver'

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
    pattern='^@lxpanel.*$'
    # pattern='^#\s*@lxpanel.*$'
    sudo sed -i -r "s/$pattern/#@lxpanel --profile LXDE/1" $autoStartConfPath
    echo -e "\tdone"
else
    echo -e "\t\t${RED}autostart config not found in: "$autoStartConfPath"${NC}"
    # touch $xscreensaverConfPath
    # echo 'mode:           off' > $autoStartConfPath
fi


############ Configure onboard ############
sudo yes | cp -rf /tmp/onboard-autostart.desktop /etc/xdg/autostart/onboard-autostart.desktop 

