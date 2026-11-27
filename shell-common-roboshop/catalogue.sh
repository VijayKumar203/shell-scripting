#!/bin/bash

app_name=catalogue
source ./common.sh

roboshop_user
application_setup
nodejs_installation
service_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE "Copied mongo repo"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE "Installed mongodb client"

INDEX=$(mongosh $MONGODB_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>> $LOG_FILE
    VALIDATE "Loaded catalogue products"
else
    echo -e "catalogue products already Loaded ... $Y SKIPPING $N"
fi

app_restart
print_total_time

# How to run this script
# sudo sh catalogue.sh