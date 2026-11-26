#!/bin/bash

SOURCE_DIR=/home/ec2-user/var/log/shell-roboshop

if [ -d $SOURCE_DIR ]; then
    echo -e "ERROR:: $SOURCE_DIR does not exist"
    exit 1
else
    echo "Exist"
fi
