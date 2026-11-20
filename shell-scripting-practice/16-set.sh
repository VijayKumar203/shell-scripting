# #!/bin/bash

# set -e 

# # error(){
# #     echo "There is an error in $LINENO, Command is: $BASH_COMMAND"
# # }
# # trap 'error' ERR

# trap 'echo "There is an error in $LINENO, Command is: $BASH_COMMAND"' ERR

# echo "Hello.."
# echo "Before error.."
# dnf install myslq -y # here shell understands there is an error and signal is ERR
# echo "After error"

script=$PWD
echo "$script"
echo "$(pwd)"
echo "a=$(pwd)"
echo "b=$pwd"
