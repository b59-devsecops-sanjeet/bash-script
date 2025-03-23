#!/bin/bash

component=backend
logFile=/tmp/$component.log
appUser=expense
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

echo -n "Installing NodeJS:"
dnf module disable nodejs -y    &>> $logFile
dnf module enable nodejs:20 -y  &>> $logFile
dnf install nodejs -y           &>> $logFile
stat $? 

echo -n "Creating Application User - $appUser :"
mkdir /app
useradd $appUser &>> $logFile
stat $? 