#!/bin/bash

source ./common.sh

redis_installation

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e 'protected-mode/c protected-mode no' /etc/redis/redis.conf
VALIDATE "Allow remote connections & Disabled protected mode"

systemctl enable redis &>> $LOG_FILE
VALIDATE "Enabled Redis"

systemctl restart redis &>> $LOG_FILE
VALIDATE "Sarting Redis"

print_total_time

# How to run this script
# sudo sh redis.sh