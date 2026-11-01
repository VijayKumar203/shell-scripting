#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo -e "$G Hello World $N"
echo "Check this color"

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root privelege $N"
    exit 1 # failure is other than 0
fi

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo -e "Installing $1... is FAILURE"
        exit 1
    else
        echo "Installing $1 is SUCCESS"
    fi
}

dnf install mysqld -y
VALIDATE "MySQL"

dnf install nginx -y
VALIDATE "Nginx"

dnf install python3 -y
VALIDATE "Python"
