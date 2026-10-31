#!/bin/bash

echo "Enter a Number: "
read -r -p "Enter a number: " a
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

echo "The Entered Number is : $a"