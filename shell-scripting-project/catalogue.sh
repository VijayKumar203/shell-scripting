#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"
USERID=$(id -u)

LOGS_FOLDER="/var/log/roboshop-catalogue"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/14-logs.log
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.vijaydev.me

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

# NodeJS #
dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE "Disabling the nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE "Enabling NodeJS 20"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE "Installing NodeJS"

id roboshop &>> $LOG_FILE

if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    VALIDATE "Created System User"
else
    echo -e "User already exists ... $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE "Created app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>> $LOG_FILE
VALIDATE "Downloading catalogue application"

cd /app 
VALIDATE "Changing the app directory"

rm -rf /app/*
VALIDATE "Removing Existing code"

unzip /tmp/catalogue.zip &>> $LOG_FILE
VALIDATE "unzip catalogue application"

npm install &>> $LOG_FILE
VALIDATE "Installing the dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE "Copied systemctl service file"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE "daemon reloaded"

systemctl enable catalogue &>> $LOG_FILE
VALIDATE "enable catalogue"

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

systemctl restart catalogue &>> $LOG_FILE
VALIDATE "Restarted catalogue"

# How to run this script
# sudo sh catalogue.sh
