#!/bin/bash

#########################################################################
#          Import structure / data to the mysql database                #
#########################################################################

# to run sql script on the mysql database / import data from sql script
mysql -u user -p < script.sql

# to run sql script on the specific database / import data from sql script to the specific database
mysql -u user -p data_base_name < script.sql 


#########################################################################
#                           VIA SSH                                     #
#########################################################################
# to run sql script located on the remote host 
ssh root@host "mysql -u user -p database < filename.sql"

# to run sql script located locally 
ssh root@host "mysql -u user -p database" < filename.sql
