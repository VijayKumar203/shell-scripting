#!/bin/bash

source ./common.sh

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE "Adding Mongo repo"

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE "Installing MongoDB"

systemctl enable mongod &>> $LOG_FILE
VALIDATE "Enabled MongoDB"

systemctl start mongod &>> $LOG_FILE
VALIDATE "Started MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_FILE
VALIDATE "Allowing remote connections to MongoDB"

systemctl restart mongod &>> $LOG_FILE
VALIDATE "Restarted MongoDB"

print_total_time

# How to run this script
# sudo sh mongodb.sh