#!/bin/bash

component=mysql
logfile=/tmp/$component.log
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

echo -n "Installing $component server:"
dnf install mysql-server -y &>> $logfile
stat $?

echo -n "Starting $component server:"
systemctl enable mysqld &>> $logfile
systemctl start mysqld &>> $logfile
stat $?

echo -n "Configuring $component root password:"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $logFile
stat $? 

echo -n "*****  $component Execution Completed  *****"