#!/bin/bash

source ./common.sh

roboshop_user
application_setup
goland_setup
service_setup
app_restart
print_total_time

# How to run this script
# sudo sh dispatch.sh