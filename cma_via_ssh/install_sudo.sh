#!/bin/bash

rPassword=""

isInstalled() {
  target=$1
  isInstalledResult=$(dpkg-query -l $target)

  if [[ $isInstalledResult ]]; then
  # if dpkg-query -l xinit; then
      echo -e "$target is allready installed"
     return 0
  else
      echo -e "$target is not installed"
      return 1
  fi
}

checkRootPassword() {
  if [ -z "${rPassword}" ]; then
    # echo -e "enter root password"
    read -p 'Enter root password:' rPassword
  # else
    # echo -e "has root password!"
  fi
}

isHasSudoAccess() {
  # printf "mypassword\n" | sudo -S /bin/chmod --help >/dev/null 2>&1
  # if [ $? -eq 0 ];then
  if sudo -nv 2>&1;then
     echo -e "User $(whoami) has sudo access!"
     return 0
  else
     echo -e "User $(whoami) has no sudo access"
     echo -e "\twill try to grant sudo..."
     return 1
  fi
}


packageName="sudo"
if isInstalled $packageName; then
    echo
    # echo -e "sudo is installed"
else
    echo -e "installing sudo..."
    checkRootPassword
    echo $rPassword | su -c "apt install $packageName -y"
fi 


if isHasSudoAccess; then
  echo
else
  # uncomment following string in /etc/sudoers
  #%sudo  ALL=(ALL:ALL) ALL
  checkRootPassword
  echo -e $rPassword | su -c "sed --in-place '/^#\s*%sudo\s\+ALL\s*=\s*(/s/^#//g' /etc/sudoers"
  echo
  read -p "Enter user name, to add to sudo (defoult $(whoami)): " userName

  if [ ! $userName ]; then
    userName=$(whoami)
  fi

  userId=$(id -u $userName)

  if [ $userId ]; then
    echo -e "user found, id = $userId [$userName]"
    echo -e $rPassword | su -c "sudo usermod -a -G sudo $userName"
  else
    echo -e "user not found, id = $userId [$userName]"
    echo -e $rPassword | su -c "sudo useradd -g sudo $userName"
  fi
  # echo -e $rPassword | su -c "sudo reboot"
fi
