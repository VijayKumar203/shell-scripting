#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

VALIDATE(){
    if [ $? -eq 0 ]; then
        echo "Installing $1 is SUCCESS"
        exit 1
    else
        echo "ERROR: Installing $1 is FAILURE"
    fi
}

dnf install mysql -y
VALIDATE "MySQL"

dnf install nginx -y
VALIDATE "Nginx"

