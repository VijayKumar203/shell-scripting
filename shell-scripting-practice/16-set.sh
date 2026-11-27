#!/bin/bash

set -e 

# error(){
#     echo "There is an error in $LINENO, Command is: $BASH_COMMAND"
# }
# trap 'error' ERR

trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Before error.."
read -p "Enter a aws command: " a  # here shell understands there is an error and signal is ERR
VALUE=$($a)
echo "Command returns value: $VALUE"
echo "After error.."

# How to run this script
# sudo sh 16-set.sh