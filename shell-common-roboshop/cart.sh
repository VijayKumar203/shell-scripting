#!/bin/bash

app_name=cart
source ./common.sh
roboshop_user
application_setup
nodejs_installation
service_setup
app_restart
print_total_time

# How to run this script
# sudo sh cart.sh