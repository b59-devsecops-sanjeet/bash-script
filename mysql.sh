#!/bin/bash

component=mysql
logfile=/tmp/$component.log
#Common function to print the status of the script
if [ $(id -u) -ne 0 ]; then 
    echo -e "\e[31m You should be root user to perform this script \e[0m"
    echo -e "Example usage: \n\t \e[35m sudo bash $0 \e[0m"
    exit 2
fi

if [ -z $1 ]; then 
    echo -e "\e[31m Please provide the password to set for root user \e[0m"
    echo -e "Example usage: \n\t \e[35m sudo bash $0 password \e[0m"
    exit 1
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

echo -n "Configuring $component root password: "
# Set root password via SQL
mysql --connect-expired-password <<EOF &>> $logfile
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${$1}';
FLUSH PRIVILEGES;
EOF
stat $? 

echo -n "*****  $component Execution Completed  *****"