#!/bin/bash

read -r "Enter a number: " a
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

read -r -p "Enter a number: " b
read -r -p -s "Enter a number: " c
echo "The Entered Number is : $a, $b, $c"
