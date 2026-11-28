#!/bin/bash

source ./common.sh

rm -rf /usr/share/nginx/html/* 
VALIDATE "Removing exist code"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE "Downloading frontend application"

cd /usr/share/nginx/html 
VALIDATE "Changing directory"

unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE "unzip frontend"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
VALIDATE "Created nginx reverse proxy"

systemctl restart nginx 
VALIDATE "Restarted nginx"

print_total_time

# How to run this script
# sudo sh catalogue.sh