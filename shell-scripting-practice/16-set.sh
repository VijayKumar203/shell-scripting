#!/bin/bash

set -e 

# error(){
#     echo "There is an error in $LINENO, Command is: $BASH_COMMAND"
# }
# trap 'error' ERR

trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

echo "Hello.."
echo "Before error.."
ids # here shell understands there is an error and signal is ERR
echo "If no error in the above Command"
