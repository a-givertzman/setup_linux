#!/bin/bash

#create startup script
sudo cp ./init_app.sh ~/.gnomerc
sudo chmod +x ~/.gnomerc

#create target
sudo cp ./scada-app.target /etc/systemd/system/scada-app.target
sudo mkdir /etc/systemd/system/scada-app.target.wants


#create service
sudo cp ./init_api_server_app.service /lib/systemd/init_api_server_app.service
sudo cp ./init_socket_data_server_app.service /lib/systemd/init_socket_data_server_app.service


#create links to the services
sudo ln /lib/systemd/init_api_server_app.service /etc/systemd/system/init_api_server_app.service
sudo ln /lib/systemd/init_api_server_app.service /etc/systemd/system/scada-app.target.wants/init_api_server_app.service

sudo ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/init_socket_data_server_app.service
sudo ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/scada-app.target.wants/init_socket_data_server_app.service


#stoping and disabling services if exists
sudo systemctl stop init_api_server_app.service
sudo systemctl stop init_socket_data_server_app.service

sudo systemctl disabled init_api_server_app.service
sudo systemctl disabled init_socket_data_server_app.service


#starting and enabling services
sudo systemctl daemon-reload

sudo systemctl start init_api_server_app.service
sudo systemctl enable init_api_server_app.service

sudo systemctl start init_socket_data_server_app.service
sudo systemctl enable init_socket_data_server_app.service
