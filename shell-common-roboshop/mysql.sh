#!/bin/bash

source ./common.sh

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE "Installing mysql server"

systemctl enable mysqld &>> $LOG_FILE
VALIDATE "enable mysql"

systemctl start mysqld  &>> $LOG_FILE
VALIDATE "Start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG_FILE
VALIDATE "MySQL setup root password"

print_total_time

# How to run this script
# sudo sh mysql.sh