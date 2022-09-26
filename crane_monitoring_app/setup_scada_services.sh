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

sudo systemctl disabled api_server.service
sudo systemctl disabled data_server.service

#create service
sudo cp ./api_server.service /etc/systemd/system/api_server.service
sudo cp ./data_server.service /etc/systemd/system/data_server.service

sudo chmod +x /etc/systemd/system/api_server.service
sudo chmod +x /etc/systemd/system/data_server.service


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
