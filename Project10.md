# LOAD BALANCER USING NGINX AND SSL/TLS

### Configure Nginx As Load Balancer

- Create Ubuntu Server 20.04 LTS EC2 VM and add TCP port 80 and TCP port 443
![Screenshot from 2022-02-26 17-00-48](https://user-images.githubusercontent.com/80127136/155906726-0cfd5278-40ac-4685-a81d-2d518f8b968f.png)



- Updated /etc/hosts file for local DNS with Web Server that I created in project 7
![Screenshot from 2022-02-26 17-04-39](https://user-images.githubusercontent.com/80127136/155906740-5d80d6d0-95f1-4f41-9202-f07480a56058.png)
![Screenshot from 2022-02-26 17-05-15](https://user-images.githubusercontent.com/80127136/155906745-42019637-46c4-4835-a495-c9de47f406ba.png)


- Install and configure nginx as load balancer to point traffic to resolvable DNS names of the webservers using `sudo apt install nginx` to install nginx, enable and check nginx status.
![Screenshot from 2022-02-26 17-05-40](https://user-images.githubusercontent.com/80127136/155906757-e5d8e60c-2d36-4e10-8557-77fceaa751aa.png)
![Screenshot from 2022-02-26 17-11-34](https://user-images.githubusercontent.com/80127136/155906784-a3f356ab-eb5f-4322-bae6-a2b5a206c937.png)

### Register New Domain Name and Configure Secured Connection Using SSL/TLS Certificate

- I faced a lot of problem when I am creating doman name on freenom.com which I was able to resolve with the help of the community channel and some videos. Then I create the domain name gabrieldaveps.gl which is not available now because I have termainated all my AWS instances. After creating the domain name I used the Load Balancer Server Public IP address in the domain manage section. I used public IP address instead of elastic IP address because someone told me that they charge per-hour for it and I realized that it will not charge me for it if I do connect it with instance and do not create more than one. 
![Screenshot from 2022-02-27 10-18-28](https://user-images.githubusercontent.com/80127136/155906856-5c49729d-c122-4650-ba4b-e61b27e25d02.png)
![Uploading Screenshot from 2022-02-27 15-07-59.png…]()

- Testing the domain name on browser
![Screenshot from 2022-02-27 15-21-34](https://user-images.githubusercontent.com/80127136/155906976-34e5ddfa-b3a1-4cbd-812b-2857091d4cb5.png)

- I installed `certbot` with snap tool with `sudo snap install --classic`.
![Screenshot from 2022-02-27 15-30-58](https://user-images.githubusercontent.com/80127136/155906958-808c3929-6125-4307-bb1d-27cf83272ae1.png)

- Then create the certificate by running `sudo certbot --nginx`.
![Screenshot from 2022-02-27 15-38-32](https://user-images.githubusercontent.com/80127136/155907031-50f531c3-c0aa-4334-9376-53567af832c4.png)
![Screenshot from 2022-02-27 15-37-34](https://user-images.githubusercontent.com/80127136/155907016-8edf7960-ab66-434e-8e70-4966db1eae78.png)

- Add the command `sudo certbot reset --dry-run` to run the comman periodically by adding `* */12 * * *   root /usr/bin/certbot renew > /dev/null 2>&1` to crontab.
![Screenshot from 2022-02-27 15-41-55](https://user-images.githubusercontent.com/80127136/155907050-076692ab-b648-444f-96ad-ddd98cd0d8c6.png)
![Screenshot from 2022-02-27 15-44-30](https://user-images.githubusercontent.com/80127136/155907055-06acbae2-99ae-44a0-b306-6bdcce0dbb93.png)

- Then I reload the website where I get a secure website on reloading
![Screenshot from 2022-02-27 17-07-41](https://user-images.githubusercontent.com/80127136/155907214-7c8d89a9-1573-4850-bfd3-c448d3c5ec25.png)
![Screenshot from 2022-02-27 17-08-29](https://user-images.githubusercontent.com/80127136/155907233-74eccc32-c1e2-4365-86fd-a94655c2e409.png)

Thank You
