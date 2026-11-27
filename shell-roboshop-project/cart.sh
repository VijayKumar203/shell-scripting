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

# Cart #

dnf module disable nodejs -y &>> $LOG_FILE
VALIDATE "Disabled default nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE "Enabled nodejs 20"

dnf install nodejs -y &>> $LOG_FILE
VALIDATE "Installed nodejs"

id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE "Created System User"
else
    echo -e "User already exists ... $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE "Created app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>> $LOG_FILE
VALIDATE "Downloaded cart application"

cd /app 
VALIDATE "Changing the directory"

rm -rf /app/* &>> $LOG_FILE
VALIDATE "Removing Existing code"

unzip /tmp/cart.zip &>> $LOG_FILE
VALIDATE "unzip cart application"

npm install &>> $LOG_FILE
VALIDATE "Installing the dependencies"

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service
VALIDATE "copying systemctl service file"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE "daemon reloaded"

systemctl enable cart &>> $LOG_FILE
VALIDATE "Enabled cart"

systemctl restart cart &>> $LOG_FILE
VALIDATE "Started cart"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME-$START_TIME))
echo -e "script executed in: $Y $TOTAL_TIME seconds $N"

# How to run this script
# sudo sh cart.sh