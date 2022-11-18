#!/bin/bash

#create startup script
# sudo cp ./init_app.sh ~/.gnomerc
# sudo chmod +x ~/.gnomerc

#create target
# sudo cp ./scada-app.target /etc/systemd/system/scada-app.target
# sudo mkdir /etc/systemd/system/scada-app.target.wants

#stoping and disabling services if exists
sudo systemctl stop api_server.service
sudo systemctl stop data_server.service
sudo systemctl stop configure_ui.service
sudo systemctl stop scada_app.service

sudo systemctl disabled api_server.service
sudo systemctl disabled data_server.service
sudo systemctl disabled configure_ui.service
sudo systemctl disabled scada_app.service

# create ui configuration script
sudo cp ./configure_ui.sh /home/scada/app/configure_ui.sh
sudo chmod +x /home/scada/app/configure_ui.sh


#create service
sudo cp ./api_server.service /etc/systemd/system/api_server.service
sudo cp ./data_server.service /etc/systemd/system/data_server.service
sudo cp ./configure_ui.service /etc/systemd/system/configure_ui.service
sudo cp ./scada_app.service /etc/systemd/system/scada_app.service

sudo chmod +x /etc/systemd/system/api_server.service
sudo chmod +x /etc/systemd/system/data_server.service
sudo chmod +x /etc/systemd/system/configure_ui.service
sudo chmod +x /etc/systemd/system/scada_app.service


#create links to the services
# sudo ln /lib/systemd/init_api_server_app.service /etc/systemd/system/init_api_server_app.service
# sudo ln /lib/systemd/init_api_server_app.service /etc/systemd/system/scada-app.target.wants/init_api_server_app.service

# sudo ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/init_socket_data_server_app.service
# sudo ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/scada-app.target.wants/init_socket_data_server_app.service



#starting and enabling services
sudo systemctl daemon-reload

sudo systemctl enable api_server.service
sudo systemctl start api_server.service

sudo systemctl enable data_server.service
sudo systemctl start data_server.service

sudo systemctl enable configure_ui.service
sudo systemctl start configure_ui.service

sudo systemctl enable scada_app.service
sudo systemctl start scada_app.service
