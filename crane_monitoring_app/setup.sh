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

read -p "Install python ? 0 - no, 1 - yes: " installpython
if [ $installpython == 0 ]; then
  echo "Cntinue without installing python"
else
  echo "\n\ninstalling puthon not implemented yet!!!" 
fi

read -p "Install python pip ? 0 - no, 1 - yes: " installpythonPip
if [ $installpythonPip == 0 ]; then
  echo "Cntinue without installing python pip"
else
  echo "\n\ninstalling puthon pip"
  sudo apt update 
  sudo apt install python3-pip
fi

read -p "Install Mysql? 0 - no, 1 - yes: " installMysql
if [ $installMysql == 0 ]; then
  echo "Cntinue without installing MySQL"
else
  echo "\n\nInstalling MySQL Server..." 
  cd /tmp/
  mySqlPackege="mysql-apt-config_0.8.22-1_all.deb"
  wget "https://dev.mysql.com/get/$mySqlPackege"
  sudo dpkg -i $mySqlPackege
  #rm -f $mySqlPackege
  sudo apt update
  sudo apt-get install mysql-server
  #sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
  #bind-address=127.0.0.1
  systemctl restart mysql
fi

read -p "Install python mysql.connector? 0 - no, 1 - yes: " installMysqlConnector
if [ $installMysqlConnector == 0 ]; then
  echo "Cntinue without installing mysql-connector-python"
else
  echo "\n\ninstalling mysql-connector-python" 
  python3 -m pip install mysql-connector-python
fi

# sudo apt install gnome-control-center

mkdir ~/developer
mkdir ~/developer/flutter-proj
mkdir ~/developer/python-proj
cd ~/developer/

read -p "Install git & curl ? 0 - no, 1 - yes: " installGit
if [ $installGit == 0 ]; then
  echo "Cntinue without installing mysql-connector-python"
else
  echo "\n\ninstalling git" 
  sudo apt update && sudo apt install git
  echo "\n\ninstalling curl" 
  sudo apt-get install curl
fi

read -p "Install dart & curl ? 0 - no, 1 - yes: " installDart
if [ $installDart == 0 ]; then
  echo "Cntinue without installing dart"
else
  echo "\n\ninstalling dart" 
  sudo apt install dart
  dart --disable-analytics
  dart --version
fi

read -p "Install flutter & curl ? 0 - no, 1 - yes: " installflutter
if [ $installflutter == 0 ]; then
  echo "Cntinue without installing flutter"
else
  echo "\n\ninstalling flutter" 
  git clone https://github.com/flutter/flutter.git -b stable
  export PATH="$PATH:~/developer/flutter/bin"
  which flutter dart
  sudo apt update
  sudo apt install clang cmake ninja-build libgtk-3-dev
  flutter doctor -v
fi

#ssh-keygen -t ed25519 -C a.givertzman@icloud.com
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_ed25519
3cat ~/.ssh/id_ed25519.pub

#ssh -T git@github.com


echo "\n\ninstalling python server application s7-data-server..." 
cd ~/developer/python-proj/ 
rm -r -f ~/developer/python-proj/s7-data-server 
git clone git@github.com:a-givertzman/s7-data-server.git -b ied-reading-in-thread 

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
