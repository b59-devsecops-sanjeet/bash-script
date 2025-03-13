#!/bin/bash
echo "Installing Nginx"
dnf install nginx -y &>> /tmp/frontend.log
echo "Configuring Nginx"
systemctl enable nginx &>> /tmp/frontend.log 
systemctl start nginx &>> /tmp/frontend.log