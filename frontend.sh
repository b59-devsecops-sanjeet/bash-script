#!/bin/bash
echo -e "Installing Nginx"
dnf install nginx -y &>> /tmp/frontend.log
systemctl enable nginx &>> /tmp/frontend.log 
systemctl start nginx &>> /tmp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Nginx Installed Successfully \e[0m"
else
  echo -e "Nginx Installation Failed"
  exit 1
fi

echo -n "Clearning Old frontend Content:"
rm -rf /usr/share/nginx/html/* 
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi
echo -e "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi
echo -e "Extracting Frontend Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /temp/frontend.log
if [ $? -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "\e[32m Failed \e[0m"
fi

echo -e "Restarting Nginx"
systemctl restart nginx

echo -n "****** Frontend Execution Completed ******"
