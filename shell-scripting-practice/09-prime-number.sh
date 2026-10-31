#!/bin/bash

read -r -p "Enter a value: " a
echo "Enter b value"
read -r b
# -r prevents backslash escapes from being interpreted
# -p displays a prompt message

read -s -r -p "Enter c value: " c

read -p "Enter d value: " d
read -s -p "Enter e value: " e
echo "Enter f value"
read f
echo "The Entered Number are : $a, $b, $c, $d, $e, $f"
