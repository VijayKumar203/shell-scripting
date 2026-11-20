#!/bin/bash

set -e 

# error(){
#     echo "There is an error in $LINENO, Command is: $BASH_COMMAND"
# }
# trap 'error' ERR

trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Before error.."
read $1  # here shell understands there is an error and signal is ERR
echo "$1"
echo "If there is no error then only this line will execute"
