#!/bin/bash

echo "Please enter your PIN number"
read -s PIN_NUMBER # here PIN_NUMBER is variable

echo "PIN number entered is: $PIN_NUMBER"

# How to run this file
# sh 03-atmpin.sh

read -r -p "Enter a value: " a
echo "Enter b value"
read -r b
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

read -s -r -p "Enter c value: " c

echo "The Entered Number are : $a, $b, $c"
