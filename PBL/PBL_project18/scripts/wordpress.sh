#!/bin/bash

#Update APT
sudo echo 'nameserver 10.0.0.2' >> /etc/resolv.conf
sudo apt update
#Install apache
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo apt install python ntp net-tools vim wget telnet epel-release htop -y
sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip tar -y
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo rm latest.tar.gz
sudo rm -r /var/www/html/*
sudo mv wordpress/* /var/www/html/
sudo rmdir wordpress
sudo apt-get install php7.4 php7.4-fpm -y
# sudo echo "server {
# index index.php;
# location ~ \.php$ {
#  include snippets/fastcgi-php.conf;
        
#  fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
# }
# }" >> /etc/nginx/conf.d/test.conf
sudo apt-get install php-mysql php-mbstring php-xml php-gd php-curl php-bcmath php-ldap mlocate php-fpm -y
sudo systemctl reload apache2










