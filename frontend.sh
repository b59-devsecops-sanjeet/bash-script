#!/bin/bash

component=frontend
logfile=/tmp/frontend.log
#Common function to print the status of the script
if [ $(id -u) -ne 0 ]; then 
    echo -e "\e[31m You should be root user to perform this script \e[0m"
    echo -e "Example usage: \n\t \e[35m sudo bash $0 \e[0m"
    exit 2
fi

stat () {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m Success \e[0m"
else
  echo -e "Failed"
  exit 1
fi
}


echo -n "Installing Nginx:"
dnf install nginx -y &>> $logfile
stat $?

echo "configuring proxy"
cp expense.conf /etc/nginx/default.d/expense.conf &>> $logfile
stat $?

echo -n "Starting Nginx:"
systemctl enable nginx &>> $logfile
systemctl start nginx &>> $logfile
stat $?

echo -n "Clearning Old frontend Content:"
rm -rf /usr/share/nginx/html/* 
stat $?

echo -n "Downloading Frontend Content:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> $logfile
stat $?

echo -n "Extracting Frontend Content:"
cd /usr/share/nginx/html
unzip /tmp/$component.zip &>> $logfile
stat $?

echo -e "Restarting Nginx"
systemctl restart nginx

echo -n "****** Frontend Execution Completed ******"
