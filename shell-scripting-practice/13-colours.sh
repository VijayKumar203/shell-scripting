#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"

# echo -e "$G Hello World $N"
# echo "Check this color"

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e $R"ERROR:: Please run this script with root privelege $N"
    exit 1 # failure is other than 0
fi

CHECK(){
    if [ $? -ne 0 ]; then
        dnf install $1 -y
        VALIDATE "$1"
    else
        echo -e "$B $1 $N already exist ... $Y SKIPPING $N"
    fi
}

VALIDATE(){
    if [ $? -ne 0 ]; then
        echo -e "Installing $B $1 $N ... is $R FAILURE $N"
        exit 1
    else
        echo -e "Installing $B $1 ... $N is $G SUCCESS $N"
    fi
}

dnf list installed mysql # Checks whether mysql is installed in the current server or not
# Install if it is not found
CHECK mysql

dnf list installed nginx
CHECK nginxs

dnf list installed python3
CHECK python3
