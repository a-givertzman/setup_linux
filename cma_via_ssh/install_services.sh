#!/bin/bash

# read rPassword <<<$@
# echo -e "\tRoot password: $rPassword"

#create startup script
# sudo cp ./init_app.sh ~/.gnomerc
# sudo chmod +x ~/.gnomerc

#create target
# sudo cp ./scada-app.target /etc/systemd/system/scada-app.target
# sudo mkdir /etc/systemd/system/scada-app.target.wants

#stoping and disabling services if exists

{
    systemctl stop api_server.service
    systemctl stop data_server.service
    systemctl stop configure_ui.service
    systemctl stop scada_app.service

    systemctl disabled api_server.service
    systemctl disabled data_server.service
    systemctl disabled configure_ui.service
    systemctl disabled scada_app.service
} &> /dev/null

# create ui configuration script
cp $(dirname -- "$0")/configure_ui.sh /home/scada/app/configure_ui.sh
chmod +x /home/scada/app/configure_ui.sh


#create service
cp $(dirname -- "$0")/api_server.service /etc/systemd/system/api_server.service
cp $(dirname -- "$0")/data_server.service /etc/systemd/system/data_server.service
cp $(dirname -- "$0")/configure_ui.service /etc/systemd/system/configure_ui.service
cp $(dirname -- "$0")/scada_app.service /etc/systemd/system/scada_app.service

chmod +x /etc/systemd/system/api_server.service
chmod +x /etc/systemd/system/data_server.service
chmod +x /etc/systemd/system/configure_ui.service
chmod +x /etc/systemd/system/scada_app.service


#create links to the services
# ln /lib/systemd/init_api_server_app.service /etc/systemd/system/init_api_server_app.service
# ln /lib/systemd/init_api_server_app.service /etc/systemd/system/scada-app.target.wants/init_api_server_app.service

# ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/init_socket_data_server_app.service
# ln /lib/systemd/init_socket_data_server_app.service /etc/systemd/system/scada-app.target.wants/init_socket_data_server_app.service



#starting and enabling services
systemctl daemon-reload

systemctl enable api_server.service
systemctl start api_server.service

systemctl enable data_server.service
systemctl start data_server.service

systemctl enable configure_ui.service
systemctl start configure_ui.service

systemctl enable scada_app.service
systemctl start scada_app.service
