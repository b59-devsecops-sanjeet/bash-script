#!/bin/bash

component=frontend
echo -n "Installing Nginx:"
dnf install nginx -y &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "Failed"
  exit 1
fi

echo -n "Starting Nginx:"
systemctl enable nginx &>> /tmp/frontend.log 
systemctl start nginx &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e " Failed"
  exit 1
fi

echo -n "Clearning Old frontend Content:"
rm -rf /usr/share/nginx/html/* 
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi

echo -n "Downloading Frontend Content:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi

echo -n "Extracting Frontend Content:"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi

echo -e "Restarting Nginx"
systemctl restart nginx

echo -n "****** Frontend Execution Completed ******"
