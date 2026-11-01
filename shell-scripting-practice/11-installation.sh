#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root privelege"
    exit 1 # failure is other than 0
fi

dnf install mysql -y

if [ $? -eq 0 ]; then
    echo "Installation of MySQL is SUCCESS"
else
    echo "ERROR: Installation of MySQL is FAILURE"
    exit 1
fi
