#!/bin/bash

testSudo() {
  printf "mypassword\n" | sudo -S /bin/chmod --help >/dev/null 2>&1
  if [ $? -eq 0 ];then
     echo -e "User $(whoami) has sudo access!"
     return 0
  else
     echo -e "User $(whoami) has no sudo access"
     echo -e "will try to grant sudo..."
     return 1
  fi
}

testSudo

hasSudo=$?
if [ hasSudo ]; then
  # uncomment following string in /etc/sudoers
  #%sudo  ALL=(ALL:ALL) ALL
  read -p 'Enter root password:' password
  echo -e $password | \
    su -c "sudo sed --in-place '/^#\s*%sudo\s\+ALL\s*=\s*(/s/^#//g' /etc/sudoers"

  read -p "Enter user name, to add to sudo (defoult $(whoami)): " userName

  if [ ! $userName ]; then
    userName=$(whoami)
  fi

  userId=$(id -u $userName)

  if [ $userId ]; then
    echo -e "user found, id = $userId [$userName]"
    echo -e $password | su -c "sudo usermod -a -G sudo $userName"
  else
    echo -e 'user not found, id = $userId [$userName]'
    echo -e $password | su -c "sudo useradd -g sudo $userName"
  fi
fi

mkdir -p ~/flutter
mkdir -p ~/app
mkdir -p ~/app/flutter-proj
mkdir -p ~/app/python-proj

echo -e "\nUpdating apt-get..."
sudo apt update

echo
read -p "Install python ? 0 - no, 1 - yes: " installpython
if [ $installpython == 0 ]; then
  echo -e "Cntinue without installing python"
else
  echo -e "\n\ninstalling puthon not implemented yet!!!" 
fi

echo
read -p "Install python pip ? 0 - no, 1 - yes: " installpythonPip
if [ $installpythonPip == 0 ]; then
  echo -e "Cntinue without installing python pip"
else
  echo -e "\n\ninstalling puthon pip"
  sudo apt update 
  sudo apt install python3-pip
fi

echo
read -p "Install Mysql? 0 - no, 1 - yes: " installMysql
if [ $installMysql == 0 ]; then
  echo -e "Cntinue without installing MySQL"
else
  echo -e "\n\nInstalling MySQL Server..." 
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

echo
read -p "Install python mysql.connector? 0 - no, 1 - yes: " installMysqlConnector
if [ $installMysqlConnector == 0 ]; then
  echo -e "Cntinue without installing mysql-connector-python"
else
  echo -e "\n\ninstalling mysql-connector-python" 
  python3 -m pip install mysql-connector-python
fi

echo
read -p "Install python-snap7 lib? 0 - no, 1 - yes: " installPythonSnap7
if [ $installPythonSnap7 == 0 ]; then
  echo -e "Cntinue without installing python-snap7"
else
  echo -e "\n\ninstalling python-snap7" 
  python3 -m pip install python-snap7
fi

# sudo apt install gnome-control-center

echo
read -p "Install git ? 0 - no, 1 - yes: " installGit
if [ $installGit == 0 ]; then
  echo -e "Cntinue without installing git"
else
  echo -e "\n\ninstalling git" 
  sudo apt update && sudo apt install git
fi

echo
read -p "Install curl ? 0 - no, 1 - yes: " installCurl
if [ $installCurl == 0 ]; then
  echo -e "Cntinue without installing curl"
else
  echo -e "\n\ninstalling curl" 
  sudo apt update && sudo apt install curl
fi


echo
read -p "Install dart ? 0 - no, 1 - yes: " installDart
if [ $installDart == 0 ]; then
  echo -e "Cntinue without installing dart"
else
  echo -e "\n\ninstalling dart" 
  sudo apt-get update
  sudo apt-get install apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt-get update
  sudo apt install dart
  dart --disable-analytics
  dart --version
fi

echo
read -p "Install flutter & curl ? 0 - no, 1 - yes: " installflutter
if [ $installflutter == 0 ]; then
  echo -e "Cntinue without installing flutter"
else
  echo -e "\n\ninstalling flutter" 
  cd ~/flutter/
  git clone https://github.com/flutter/flutter.git -b stable
  export PATH="$PATH:~/flutter/flutter/bin"
  which flutter dart
  sudo apt update
  sudo apt install clang cmake ninja-build libgtk-3-dev
  flutter doctor -v
fi

#ssh-keygen -t ed25519 -C a.givertzman@icloud.com
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_ed25519

echo -e "\nthere is allready installed ssh-key:"
cat ~/.ssh/id_ed25519.pub

echo -e "\ntesting ssh connection to the github.com..."
ssh -T git@github.com


cd ~/app/


echo -e "\n\ninstalling python server application s7-data-server..." 
cd ~/app/python-proj/ 
rm -r -f ~/app/python-proj/s7-data-server 
git clone git@github.com:a-givertzman/s7-data-server.git -b ied-reading-in-thread 

echo -e "\n\ninstalling dart/flutter client application crane_monitoring_app"
cd ~/app/flutter-proj/
rm -r -f ~/app/flutter-proj/crane_monitoring_app
git clone git@github.com:a-givertzman/crane_monitoring_app.git -b HomePage
#git clone git@github.com:a-givertzman/crane_monitoring_app.git -b master

#echo -e "\nstarting up python server application api_server..." 
#gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/app/python-proj/s7-data-server/api_server.py"
#echo -e "\nstarting up python server application socket_data_server..." 
#gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/app/python-proj/s7-data-server/socket_data_server_test.py"

cd ~/app/flutter-proj/crane_monitoring_app/
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
