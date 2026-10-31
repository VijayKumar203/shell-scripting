#!/bin/bash

read -r -p "Enter a number: " a
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

read -s -r -p "Enter a number: " b
read -r c
echo "The Entered Number is : $a, $b, $c"
