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
MYSQL_HOST=mysql.vijaydev.me
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

# Shipping #

dnf install maven -y &>> $LOG_FILE
VALIDATE "Installing maven"

id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE "Created System User"
else
    echo -e "User already exists ... $Y SKIPPING $N"
fi

mkdir -p /app
VALIDATE "Created app directory"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>> $LOG_FILE
VALIDATE "Downloading Shipping application"

cd /app 
VALIDATE "Changing the directory"

rm -rf /app/* &>> $LOG_FILE
VALIDATE "Removing existing code"

unzip /tmp/shipping.zip &>> $LOG_FILE
VALIDATE "unzip shipping application"

mvn clean package &>> $LOG_FILE
VALIDATE "clean and build the application"

mv target/shipping-1.0.jar shipping.jar 
VALIDATE "Renaming the artifact"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service
VALIDATE "copying systemctl service file"

systemctl daemon-reload &>> $LOG_FILE
VALIDATE "daemon reloaded"

systemctl enable shipping &>> $LOG_FILE
VALIDATE "enable shipping"

systemctl start shipping &>> $LOG_FILE
VALIDATE "starting shipping"

dnf install mysql -y &>> $LOG_FILE
VALIDATE "Installing mysql client"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi

systemctl restart shipping &>> $LOG_FILE
VALIDATE "Restarting shipping"

END_TIME=$(date +%s)
TOTAL_TIME=$(($END_TIME-$START_TIME))
echo -e "script executed in: $Y $TOTAL_TIME seconds $N"

# How to run this script
# sudo sh mysql.sh