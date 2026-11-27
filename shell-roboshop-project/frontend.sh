#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"
USERID=$(id -u)

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.vijaydev.me
START_TIME=$(date +%s)

if [ $USERID -ne 0 ]; then
    echo -e $R"ERROR:: Please run this script with root privelege $N"
    exit 1 # failure is other than 0 means 1-127 -> FAILURE and 0 -> SUCCESS
fi

mkdir -p $LOGS_FOLDER # Creates parent directories if they don't exist & Does not throw an error if the directory already exists.

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo -e "$B $1 $N ... is $R FAILURE $N"
        exit 1
    else
        echo -e "$B $1 $N ... is $G SUCCESS $N"
    fi
}

# frontend #

dnf module disable nginx -y &>> $LOG_FILE
VALIDATE "Disabling nginx"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
VALIDATE "Enabling nginx 24"

dnf install nginx -y &>> $LOG_FILE
VALIDATE "Installing nginx"

systemctl enable nginx &>> $LOG_FILE
VALIDATE "enable nginx"

systemctl start nginx &>> $LOG_FILE
VALIDATE "start nginx"

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

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME-$START_TIME))
echo -e "script executed in: $Y $TOTAL_TIME seconds $N"

# How to run this script
# sudo sh catalogue.sh