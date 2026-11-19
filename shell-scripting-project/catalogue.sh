#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"
USERID=$(id -u)

LOGS_FOLDER="/var/log/roboshop-mongodb"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/14-logs.log
SCRIPT_DIR=$pwd

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
    echo -e "User already exists ... $Y SKIPPING Skipping $N"
fi

mkdir -p /app
VALIDATE "Created app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip 
VALIDATE "Downloading catalogue application"

cd /app 
VALIDATE "Changing the app directory"

rm -rf /app/*
VALIDATE "Removing Existing code"

unzip /tmp/catalogue.zip
VALIDATE "unzip catalogue application"

npm install
VALIDATE "Installing the dependencies"

cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE "Copied systemctl service file"

systemctl daemon-reload
VALIDATE "daemon reloaded"

systemctl enable catalogue
VALIDATE "enable catalogue"

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
