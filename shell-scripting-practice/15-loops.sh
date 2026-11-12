#!/bin/bash

# for i in {1..20}
# do
#     echo $i
# done

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[44m"
N="\e[0m"
USERID=$(id -u)

LOGS_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log" # /var/log/shell-script/14-logs.log

mkdir -p $LOGS_FOLDER # Creates parent directories if they don't exist and does not throw an error if the directory already exists.

if [ $USERID -ne 0 ]; then
    echo -e $R"ERROR:: Please run this script with root privelege $N"
    exit 1 # failure is other than 0 means 1-127 -> FAILURE and 0 -> SUCCESS
fi

echo "Script start executed at: $(date)" | tee -a $LOG_FILE 
# Without -a: tee overwrites the existing file.
# With -a: tee preserves existing contents and adds new data at the end.

CHECK(){
    if [ $? -ne 0 ]; then
        dnf install $1 -y &>> $LOG_FILE
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

for package in $@
do
    dnf list installed $package &>> $LOG_FILE
    CHECK $package
done

# How to run this script
# sudo sh 15-loops.sh mysql nginx python3
