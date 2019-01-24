#!/bin/bash

server=xx.xx.xx.xx
port=xxxx
user=xxxx
pass=xxxx
databases="xx xx xx"

base_folder=/path//to/mysql_backup

keep_backup_days=2

backup_folder=`date +%Y%m%d%H%M%S`
remove_folder=`date +%Y%m%d -d "$keep_backup_days day ago"`

mkdir -p $base_folder/$backup_folder

for db in $databases;
do 
mysqldump --host=$server --port=$port --user=$user --password=$pass --routines --triggers --databases  $db > $base_folder/$backup_folder/$db.sql
done
rm -rf $base_folder/$remove_folder*
