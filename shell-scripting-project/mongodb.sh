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

mkdir -p $LOGS_FOLDER # Creates parent directories if they don't exist & Does not throw an error if the directory already exists.

if [ $USERID -ne 0 ]; then
    echo -e $R"ERROR:: Please run this script with root privelege $N"
    exit 1 # failure is other than 0 means 1-127 -> FAILURE and 0 -> SUCCESS
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo -e "$B $1 $N ... is $R FAILURE $N"
        exit 1
    else
        echo -e "$B $1 $N ... is $G SUCCESS $N"
    fi
}

cp mongodb.repo /etc/yum.repos.d/mongo.repo
VALIDATE "Adding Mongo repo"

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE "Installing MongoDB"

systemctl enable mongod 
VALIDATE "Enabled MongoDB"

systemctl start mongod 
VALIDATE "Started MongoDB"

# How to run this script
# sudo sh 
