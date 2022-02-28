# LOAD BALANCER USING NGINX AND SSL/TLS

### Configure Nginx As Load Balancer

- Create Ubuntu Server 20.04 LTS EC2 VM and add TCP port 80 and TCP port 443
- Updated /etc/hosts file for local DNS with Web Server that I created in project 7
- Install and configure nginx as load balancer to point traffic to resolvable DNS names of the webservers using `sudo apt install nginx` to install nginx, enable and check nginx status.

### Register New Domain Name and Configure Secured Connection Using SSL/TLS Certificate

- I faced a lot of problem when I am creating doman name on freenom.com which I was able to resolve with the help of the community channel and some videos. Then I create the domain name gabrieldaveps.gl which is not available now because I have termainated all my AWS instances. After creating the domain name I used the Load Balancer Server Public IP address in the domain manage section. I used public IP address instead of elastic IP address because someone told me that they charge per-hour for it and I realized that it will not charge me for it if I do connect it with instance and do not create more than one. 
- Testing the domain name on browser
- I installed `certbot` with snap tool with `sudo snap install --classic`.
- Then create the certificate by running `sudo certbot --nginx`.
- Add the command `sudo certbot reset --dry-run` to run the comman periodically by adding `* */12 * * *   root /usr/bin/certbot renew > /dev/null 2>&1` to crontab.

Thank You
