#!/bin/bash

#Update APT
sudo echo 'nameserver 10.0.0.2' >> /etc/resolv.conf
sudo apt update
#Install apache2
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo apt install python ntp net-tools vim wget telnet epel-release htop git -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y
sudo apt-get install php7.4 php7.4-fpm -y
sudo apt-get install php-mysql php-mbstring php-xml php-gd php-curl php-bcmath php-ldap mlocate php-fpm -y
git clone https://github.com/akingo7/tooling.git
sudo rm -r /var/www/html/*
sudo mv tooling/* /var/www/html/
sudo mv /var/www/html/html/* /var/www/html/
sudo rmdir /var/www/html/html/
sudo systemctl restart apache2