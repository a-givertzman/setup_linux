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

echo
read -p "Setup auto login ? n - no, y - yes: " installAutologin
if [ $installAutologin == 'n' ]; then
  echo -e "Cntinue without installing auto login"
else
  echo -e "\n\ninstalling $userName auto login..." 
  # /etc/gdm3/daemon.conf
  # AutomaticLoginEnable=True
  # AutomaticLogin=$userName
  echo -e "\n\not implemented yet!" 
fi

echo -e "\nUpdating apt-get..."
sudo apt update

echo
read -p "Install python ? 0 - no, 1 - yes: " installPython
if [ $installPython == 0 ]; then
  echo -e "Cntinue without installing python"
else
  echo -e "\n\ninstalling puthon not implemented yet!!!" 
  echo -e "\n\not implemented yet!" 
fi

echo
read -p "Install python pip ? 0 - no, 1 - yes: " installPythonPip
if [ $installPythonPip == 0 ]; then
  echo -e "Cntinue without installing python pip"
elif [ $installPythonPip == 1 ]; then
  echo -e "\n\ninstalling puthon pip"
  sudo apt update 
  sudo apt install python3-pip
else
  echo -e "Cntinue without installing python pip"
fi

echo
read -p "Install Mysql? 0 - no, 1 - yes: " installMysql
if [ $installMysql == 0 ]; then
  echo -e "Cntinue without installing MySQL"
elif [ $installMysql == 1 ]; then
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
else
  echo -e "Cntinue without installing MySQL"
fi

echo
read -p "Install python mysql.connector? 0 - no, 1 - yes: " installMysqlConnector
if [ $installMysqlConnector == 0 ]; then
  echo -e "Cntinue without installing mysql-connector-python"
elif [ $installMysqlConnector == 1 ]; then
  echo -e "\n\ninstalling mysql-connector-python" 
  python3 -m pip install mysql-connector-python
else
  echo -e "Cntinue without installing mysql-connector-python"
fi

echo
read -p "Install python-numpy lib? 0 - no, 1 - yes: " installPythonNumpy
if [ $installPythonNumpy == 0 ]; then
  echo -e "Cntinue without installing python numpy"
elif [ $installPythonNumpy == 1 ]; then
  echo -e "\n\ninstalling python numpy" 
  python3 -m pip install numpy
else
  echo -e "Cntinue without installing python numpy"
fi

echo
read -p "Install python-snap7 lib? 0 - no, 1 - yes: " installPythonSnap7
if [ $installPythonSnap7 == 0 ]; then
  echo -e "Cntinue without installing python-snap7"
elif [ $installPythonSnap7 == 1 ]; then
  echo -e "\n\ninstalling python-snap7" 
  python3 -m pip install python-snap7
else
  echo -e "Cntinue without installing python-snap7"
fi

# sudo apt install gnome-control-center

echo
read -p "Install git ? 0 - no, 1 - yes: " installGit
if [ $installGit == 0 ]; then
  echo -e "Cntinue without installing git"
elif [ $installGit == 1 ]; then
  echo -e "\n\ninstalling git" 
  sudo apt update && sudo apt install git
else
  echo -e "Cntinue without installing git"
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
elif [ $installDart == 1 ]; then
  echo -e "\n\ninstalling dart" 
  sudo apt-get update
  sudo apt-get install apt-transport-https
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt-get update
  sudo apt install dart
  dart --disable-analytics
  dart --version
else
  echo -e "Cntinue without installing dart"
fi


echo
read -p "Install flutter? 0 - no, 1 - install, 2 - upgrade: " installFlutter
if [ $installFlutter == 0 ]; then
  echo -e "Cntinue without installing flutter"
elif [ $installFlutter == 1 ]; then
  echo -e "\n\ninstalling flutter" 
  cd ~/flutter/
  git clone https://github.com/flutter/flutter.git -b stable
  export PATH="$PATH:~/flutter/flutter/bin"
  which flutter dart
  sudo apt update
  sudo apt install clang cmake ninja-build libgtk-3-dev
  flutter doctor -v
elif [ $installFlutter == 2 ]; then
  echo -e "\n\nupgrading flutter" 
  flutter upgrade
  flutter doctor -v
else
  echo -e "Cntinue without installing flutter"
fi
export PATH="$PATH:~/flutter/flutter/bin"
#ssh-keygen -t ed25519 -C a.givertzman@icloud.com
#eval "$(ssh-agent -s)"
#ssh-add ~/.ssh/id_ed25519

echo -e "\nthere is allready installed ssh-key:"
cat ~/.ssh/id_ed25519.pub

echo -e "\ntesting ssh connection to the github.com..."
ssh -T git@github.com


cd ~/app/


echo
read -p "Install s7-data-server? 0 - no, 1 - install: " s7DataServer
if [ $s7DataServer == 0 ]; then
  echo -e "Cntinue without installing s7-data-server"
elif [ $s7DataServer == 1 ]; then
  echo -e "\n\ninstalling python server application s7-data-server..." 
  cd ~/app/python-proj/ 
  rm -r -f ~/app/python-proj/s7-data-server 
  git clone git@github.com:a-givertzman/s7-data-server.git -b DsDataPoint-history-alarm-attributes
  # git clone git@github.com:a-givertzman/s7-data-server.git -b master
else
  echo -e "Cntinue without installing s7-data-server"
fi


echo
read -p "Install crane_monitoring_app? 0 - no, 1 - install: " craneMonitoringApp
if [ $craneMonitoringApp == 0 ]; then
  echo -e "Cntinue without installing crane_monitoring_app"
elif [ $craneMonitoringApp == 1 ]; then
  echo -e "\n\ninstalling dart/flutter client application crane_monitoring_app"
  cd ~/app/flutter-proj/
  rm -r -f ~/app/flutter-proj/crane_monitoring_app
  # git clone git@github.com:a-givertzman/crane_monitoring_app.git -b master
  git clone git@github.com:a-givertzman/crane_monitoring_app.git -b Testing
else
  echo -e "Cntinue without installing crane_monitoring_app"
fi

cd ~/app/

#echo -e "\nstarting up python server application api_server..." 
#gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/app/python-proj/s7-data-server/api_server.py"
#echo -e "\nstarting up python server application socket_data_server..." 
#gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/app/python-proj/s7-data-server/socket_data_server_test.py"

cd ~/app/flutter-proj/crane_monitoring_app/
flutter config --enable-linux-desktop
flutter devices
flutter doctor
flutter clean
flutter pub upgrade
flutter create --platforms=macos,linux ./

echo
read -p "run flutter application? 0 - no, 1 - run debug, 2 - run release, 3 - jast duild: " buildFlutterApp
if [ $buildFlutterApp == 0 ]; then
  echo -e "Cntinue without installing flutter"
elif [ $buildFlutterApp == 1 ]; then
  echo -e "\n\nrunning flutter application in the debug mode..." 
  flutter run -d linux
elif [ $buildFlutterApp == 2 ]; then
  echo -e "\n\nrunning flutter application in the release mode..." 
  flutter build linux
elif [ $buildFlutterApp == 3 ]; then
  echo -e "\n\nbulding flutter application..." 
  flutter build linux
else
  echo -e "exit without running/building flutter application"
fi

exit 0
