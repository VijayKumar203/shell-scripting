#!/bin/bash

source ./common.sh

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
VALIDATE "Copying rabbitmq repo file"

dnf install rabbitmq-server -y &>> $LOG_FILE
VALIDATE "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOG_FILE
VALIDATE "enable rabbitmq server"

systemctl start rabbitmq-server &>> $LOG_FILE
VALIDATE "starting rabbitmq server"

rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
VALIDATE "adding roboshop user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
VALIDATE "setting up permissions"

print_total_time

# How to run this script
# sudo sh rabbitmq.sh