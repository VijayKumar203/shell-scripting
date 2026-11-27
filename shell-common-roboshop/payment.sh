#!/bin/bash

source ./common.sh

roboshop_user
application_setup
python_setup
service_setup
app_restart
print_total_time

# How to run this script
# sudo sh payment.sh