#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root privelege $$ $N"
    # exit 1 # failure is other than 0 means 1-127 -> FAILURE and 0 -> SUCCESS
else
    echo -e "$B PID $N of $Y SCRIPT-2: $G $$ $N"
    echo -e "$Y Calling script variable : $G $NAME $N" # When this script is used in calling script if source <script-name> is used at end of the file then this statement will print the variables
fi
