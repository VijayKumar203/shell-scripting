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

SCR=$(pwd)
echo "Present Working Directory: $SCR"
SC=$PWD
echo "Present Working Directory: $SC"
