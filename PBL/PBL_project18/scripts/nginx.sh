#!/bin/bash

#Update APT
sudo echo 'nameserver 10.0.0.2' >> /etc/resolv.conf
sudo apt update
#Install nginx 
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo apt install python ntp net-tools vim wget telnet epel-release htop -y
sudo echo "server {
    listen             80;
    server_name         *.gabrieldevops.ml;

    location /yourapp {
        proxy_pass ${internalLB};
        proxy_set_header Host $host;
        
    }
    }" >> /etc/nginx/conf.d/reverse.conf

sudo systemctl reload nginx
