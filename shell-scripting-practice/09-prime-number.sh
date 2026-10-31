#!/bin/bash

read -r -p "Enter a value: " a
echo "Enter b value"
read -r b
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

read -s -r -p "Enter a number: " c
echo "The Entered Number are : $a, $b, $c"

read -r d
echo "$d"