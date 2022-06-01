#!/bin/bash

testSudo() {
  printf "mypassword\n" | sudo -S /bin/chmod --help >/dev/null 2>&1
  if [ $? -eq 0 ];then
     echo "User $(whoami) has sudo access!"
     return 0
  else
     echo "User $(whoami) has no sudo access"
     echo "will try to grant sudo..."
     return 1
  fi
}

testSudo

hasSudo=$?
if [ hasSudo ]; then
  # uncomment following string in /etc/sudoers
  #%sudo  ALL=(ALL:ALL) ALL
  read -p 'Enter root password:' password
  echo $password | \
    su -c "sudo sed --in-place '/^#\s*%sudo\s\+ALL\s*=\s*(/s/^#//g' /etc/sudoers"

  read -p "Enter user name, to add to sudo (defoult $(whoami)): " userName

  if [ ! $userName ]; then
    userName=$(whoami)
  fi

  userId=$(id -u $userName)

  if [ $userId ]; then
    echo "user found, id = $userId [$userName]"
    echo $password | su -c "sudo usermod -a -G sudo $userName"
  else
    echo 'user not found, id = $userId [$userName]'
    echo $password | su -c "sudo useradd -g sudo $userName"
  fi
fi

sudo apt update

# sudo apt install gnome-control-center

mkdir ~/developer
mkdir ~/developer/flutter-proj
mkdir ~/developer/python-proj
cd ~/developer/

sudo apt update && sudo apt install git
sudo apt-get install curl
sudo apt install dart
dart --disable-analytics
dart --version

git clone https://github.com/flutter/flutter.git -b stable

export PATH="$PATH:~/developer/flutter/bin"
which flutter dart

sudo apt update
sudo apt install clang cmake ninja-build libgtk-3-dev

flutter doctor -v

#ssh-keygen -t ed25519 -C a.givertzman@icloud.com
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_ed25519
3cat ~/.ssh/id_ed25519.pub

#ssh -T git@github.com


echo "\n\ninstalling python server application s7-data-server..." 
cd ~/developer/python-proj/ 
rm -r -f ~/developer/python-proj/s7-data-server 
git clone git@github.com:a-givertzman/s7-data-server.git -b master 

echo "\n\ninstalling dart/flutter client application crane_monitoring_app"
cd ~/developer/flutter-proj/
rm -r -f ~/developer/flutter-proj/crane_monitoring_app
#git clone git@github.com:a-givertzman/crane_monitoring_app.git -b TextStatusIndicator
git clone git@github.com:a-givertzman/crane_monitoring_app.git -b master

echo "\nstarting up python server application api_server..." 
python3 ~/developer/python-proj/s7-data-server/api_server.py
echo "\nstarting up python server application socket_data_server..." 
python3 ~/developer/python-proj/s7-data-server/socket_data_server_test.py

cd ~/developer/flutter-proj/crane_monitoring_app/
flutter upgrade
flutter config --enable-linux-desktop
flutter devices
flutter doctor
flutter clean
flutter pub upgrade
flutter create --platforms=macos,linux ./
flutter run -d linux
#flutter build linux

exit 0
