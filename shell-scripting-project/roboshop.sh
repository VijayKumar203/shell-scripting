#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f" 
SG_ID="sg-07c8acf3fa6b923fa" # replace with your SG ID
ZONE_ID="Z0948150OFPSYTNVYZOY" # replace with your ID
DOMAIN_NAME="vijaydev.me"

aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-07c8acf3fa6b923fa --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Instances[0].InstanceId' --output text

aws ec2 describe-instances --instance-ids i-0682bd1dbd92ce16c --query 'Reservations[0].Instances[0].PublicIpAddress' --output text


aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-07c8acf3fa6b923fa --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Test}]' --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text
