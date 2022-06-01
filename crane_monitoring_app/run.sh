#!/bin/bash

echo "\nstarting up python server application api_server..." 
gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/developer/python-proj/s7-data-server/api_server.py"
echo "\nstarting up python server application socket_data_server..." 
gnome-terminal --tab --title="socket_data_server_test" --command="python3 ~/developer/python-proj/s7-data-server/socket_data_server_test.py"

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
