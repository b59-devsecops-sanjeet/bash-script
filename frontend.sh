#!/bin/bash
echo -e "Installing Nginx"
dnf install nginx -y &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Nginx Installed Successfully \e[0m"
else
  echo -e "Nginx Installation Failed"
  exit 1
fi
echo -e "Configuring Nginx"
systemctl enable nginx &>> /tmp/frontend.log 
systemctl start nginx &>> /tmp/frontend.log