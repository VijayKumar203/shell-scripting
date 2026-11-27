#!/bin/bash

sh ./18-script-calling.sh    # ./ represents current folder, sh <script-name> runs in different process
# If we run sh <script-name> then it will simply run that script file from current script file. There is no connection between the two files because it simply run that file.
source ./18-script-calling.sh   # source <script-name> runs in same process
# If we run source <script-name> then the entire content in script file will be used in current script file, as like as copied the script file to current script file.
NAME=INDIA
echo "My Country: $NAME"
echo -e "$B PID $N of $Y SCRITP-1: $$ $N" # Here colours are declared in the source script file only displays colours when source <script-name> is used before current lines.
# source ./18-script-calling.sh
# sh will run the file source will use the file