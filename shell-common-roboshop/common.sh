#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"
USERID=$(id -u)

START_TIME=$(date +%s)
LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
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

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME-$START_TIME))
    echo -e "script executed in: $Y $TOTAL_TIME seconds $N"
}

nodejs_installation(){
    dnf module disable nodejs -y &>> $LOG_FILE
    VALIDATE "Disabling the nodejs"
    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE "Enabling NodeJS 20"
    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE "Installing NodeJS"    
    npm install &>> $LOG_FILE
    VALIDATE "Installing the dependencies"
}

roboshop_user(){
    id roboshop &>> $LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
        VALIDATE "Created System User"
    else
        echo -e "User already exists ... $Y SKIPPING $N"
    fi
}
application_setup(){
    mkdir -p /app
    VALIDATE "Created app directory"
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOG_FILE
    VALIDATE "Downloading $app_name application"
    cd /app 
    VALIDATE "Changing the app directory"
    rm -rf /app/*
    VALIDATE "Removing Existing code"
    unzip /tmp/$app_name.zip &>> $LOG_FILE
    VALIDATE "unzip $app_name application"
}
service_setup(){    
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE "Copied systemctl service file"
    systemctl daemon-reload &>> $LOG_FILE
    VALIDATE "daemon reloaded"
    systemctl enable $app_name &>> $LOG_FILE
    VALIDATE "enable $app_name"
}
app_restart(){
    systemctl restart $app_name &>> $LOG_FILE
    VALIDATE "Restarted $app_name"
}
redis_installation(){
    dnf module disable redis -y &>> $LOG_FILE
    VALIDATE "Disabled Default Redis"
    dnf module enable redis:7 -y &>> $LOG_FILE
    VALIDATE "Enabled Redis 7"
    dnf install redis -y &>> $LOG_FILE
    VALIDATE "Installed Redis"
}
java_setup(){
    dnf install maven -y &>> $LOG_FILE
    VALIDATE "Installing maven"
    mvn clean package &>> $LOG_FILE
    VALIDATE "clean and build the application"
    mv target/shipping-1.0.jar shipping.jar 
    VALIDATE "Renaming the artifact"
}
python_setup(){  
    dnf install python3 gcc python3-devel -y &>> $LOG_FILE
    VALIDATE "Installing Python server"    
    pip3 install -r requirements.txt &>> $LOG_FILE
    VALIDATE "Installing the dependencies"
}
goland_setup(){
    dnf install golang -y &>> $LOG_FILE
    VALIDATE "Installing golang"
    go mod init dispatch &>> $LOG_FILE
    VALIDATE "Initializes a new Go module"
    # go mod init creates a Go module.
    # dispatch is the module name.
    go get &>> $LOG_FILE
    VALIDATE "downloads and adds external Go packages (dependencies) to your project"
    go build &>> $LOG_FILE
    VALIDATE "compiles your Go source code into an executable program"
}
nginx_setup(){
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
}
