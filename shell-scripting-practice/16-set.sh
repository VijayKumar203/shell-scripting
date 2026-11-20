#!/bin/bash

set -e 

# error(){
#     echo "There is an error in $LINENO, Command is: $BASH_COMMAND"
# }
# trap 'error' ERR

trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Before error.."
read a  # here shell understands there is an error and signal is ERR
echo "Command returns value: $($a)"
echo "After error.."

# How to run this script
# sudo sh 16-set.sh