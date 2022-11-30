#!/bin/bash

# su -c 'apt update'
# su -c 'apt install lxde-core -y'
# su -c 'apt remove xscreensaver -y'
# su -c 'apt remove light-locker -y'

# autoStartConfPath='/etc/xdg/lxsession/LXDE/autostart'
xscreensaverConfPath='/home/scada/.xscreensaver'

############ Configure autostart ############
# pattern='^mode:\s*.*$'
# su -c "sed -i -r "s/$pattern/mode:    off/1" $autoStartConfPath"
# su -c "sed -ir '/$pattern/d' $autoStartConfPath"

############ Disable xscreensaver ############
if [ -f $xscreensaverConfPath ]; then
    pattern='^mode:\s*.*$'
    sed -i -r 's/$pattern/mode:           off/1' $xscreensaverConfPath
else
    # touch $xscreensaverConfPath
    echo 'mode:           off' > $xscreensaverConfPath
fi
# su -c "sed -i -r 's/^mode:\s*.*$/mode:          off/1' /home/scada/.xscreensaver"
