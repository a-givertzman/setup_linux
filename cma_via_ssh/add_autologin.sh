#!/bin/bash

autoLoginConfPath='/etc/lightdm/lightdm.conf'

sudo ls -la /etc/lightdm
echo
sudo cat $autoLoginConfPath
echo -e '\n\n'

insertAfterPattern() {
    pattern=$1
    toInsert=$2
    path=$3
    if [ -z "${pattern}" ] | [ -z "${toInsert}" ] | [ -z "${path}" ]; then
        echo -e "wrong params!"
    else
        echo -e "pattern: $pattern"
        echo -e "tpInsert: $toInsert"
        echo -e "path: $path"
        sudo awk "!found && /$pattern/ {
            print;
            print \"$toInsert\"; 
            next;
            found=1;
        } 1" $path > /tmp/insertAfterPattern.tmp
        sudo mv /tmp/insertAfterPattern.tmp $path
        echo -e "installed success!"
    fi
}

pattern='(^\s*#*\s*autologin-user=$)'
sudo sed -i -r "s/$pattern/autologin-user=scada/1" $autoLoginConfPath
pattern='(^\s*#*\s*autologin-user\s*=(.*)$)'
sudo sed -i -r "s/$pattern/scada/2" $autoLoginConfPath

if sudo cat $autoLoginConfPath | grep -E -o '^autologin-user=scada$'; then
    echo -e "Autologin installed success!"
else
    echo -e "Autologin is not installed"
    insertAfterPattern '^\s*\[Seat:\*\]\s*' 'autologin-user=scada' $autoLoginConfPath
fi

pattern='(^\s*#*\s*autologin-user-timeout=\s*\d*.*$)'
sudo sed -i -r "s/$pattern/autologin-user-timeout=0/1" $autoLoginConfPath
pattern='(^\s*#*\s*autologin-user-timeout=0$)'
sudo sed -i -r "s/$pattern/autologin-user-timeout=0/1" $autoLoginConfPath
# pattern='(^\s*#*\s*autologin-user\s*=(.*)$)'
# sed -i -r "s/$pattern/scada/2" $autoLoginConfPath

if sudo cat $autoLoginConfPath | grep -E -o '^autologin-user-timeout=0$'; then
    echo -e "Autologin timeout installed success!"
else
    echo -e "Autologin timeout is not installed"
    insertAfterPattern '^\s*\[Seat:\*\]\s*' 'autologin-user-timeout=0' $autoLoginConfPath
fi