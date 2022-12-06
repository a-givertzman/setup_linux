#!/bin/bash


#########################################################################
# Export structure / data from the mysql database                       #
#########################################################################

# to import structure from mysql database
mysqldump -u user -h localhost --no-data -p database > script.sql

# to import structure from mysql table
mysqldump -u user -h localhost --no-data -p database tablename > script.sql


#########################################################################
#                           VIA SSH                                     #
#########################################################################
ssh root@host "mysqldump -u dbusername -p dbname | gzip -9" > dblocal.sql.gz
