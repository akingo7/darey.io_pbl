# LOAD BALANCER SOLUTION WITH APACHE

### Prepare NFS Server
![Screenshot from 2022-02-25 00-15-48](https://user-images.githubusercontent.com/80127136/155741503-9a25060b-cd0c-4d0e-b26e-cace8626b1fc.png)

- I created three logical volumes and mounted them on /mnt/opt /mnt/apps, and /mnt/logs then configure the logical volume to be mounted on boot.

![Screenshot from 2022-02-25 00-56-11](https://user-images.githubusercontent.com/80127136/155742451-f3db9594-3e20-4dc9-8e61-a14a0e905508.png)
![Screenshot from 2022-02-25 00-59-44](https://user-images.githubusercontent.com/80127136/155742483-aaa372e2-266a-4fb4-b74d-a2638fcd4ef9.png)
![Screenshot from 2022-02-25 01-06-05](https://user-images.githubusercontent.com/80127136/155742550-0b326564-1cbf-48e4-8c23-33c433754540.png)

- Then I install NFS server, configure it to start on reboot and Start the service.
![Screenshot from 2022-02-25 01-22-13](https://user-images.githubusercontent.com/80127136/155743815-6dc8e47e-c4a2-4132-85cc-dbe861908e60.png)
- Then I set up permission that will allow our Web servers to read, write and execute files on NFS.
- Then I Configure access to NFS for clients within the same subnet to the directory and export then.


### Configure Database Server
![Screenshot from 2022-02-25 00-44-33](https://user-images.githubusercontent.com/80127136/155741689-840a38d9-b440-46f6-9d2c-62911e2be637.png)

- I updated apt and install mysql-server 
![Screenshot from 2022-02-25 01-14-39](https://user-images.githubusercontent.com/80127136/155743206-4f27085d-85cf-4c27-b123-c23abab0d630.png)

-Then I started it as root user, created database **tooling**, user **webaccess** with password **password** to do anything only from the webservers subnet cidr


### Prepare the Web Servers
- I Install NFS client on the web servers.
- Then mount /var/www/ and target the NFS server’s export for apps with `sudo mount -t nfs -o rw,nosuid <NFS-Server-Private-IP-Address>:/mnt/apps /var/www` after creating `/var/www/`
- Then I install Remi's repository.
![Screenshot from 2022-02-25 01-32-21](https://user-images.githubusercontent.com/80127136/155745148-c45eb258-1463-4be7-9d03-c12c56bb9a76.png)
- Fork the tooling source code from `https://github.com/darey-io/tooling.git` and clone it, then I move the html/ directory from the tooling source code to /var/www/.
- Then I added inbound rule in the security on each webservers.
- Then I Update the website's configuration to the database after editing the bind_address of mysql in the Database server and restarting it, in `/var/www/html/function.php`.
- Apply tooling-db.sql script to your database using this command `mysql -h <databse-private-ip> -u <db-username> -p <db-pasword> tooling < tooling-db.sql`.
![Screenshot from 2022-02-25 01-52-14](https://user-images.githubusercontent.com/80127136/155746708-e8b77ee4-1b90-4170-a256-2b0efc9cefc8.png)
![Screenshot from 2022-02-25 02-20-26](https://user-images.githubusercontent.com/80127136/155746758-29f8b21b-d56a-4699-b8e8-aa6d4bfdb3ad.png)



### COnfigure Apache As A Load Balancer
- Open TCP port 80 on Apache Load Balancer Server.
- Install Apache Load Balancer on Apache Load Balancer Server and configure it to point traffic coming to Load Balancer to Both Web Servers equally.
![Screenshot from 2022-02-25 02-24-34](https://user-images.githubusercontent.com/80127136/155747273-3055007c-4aa7-4a95-ac08-a7a20749fc86.png)
- Enable and start apache2
![Screenshot from 2022-02-25 02-25-49](https://user-images.githubusercontent.com/80127136/155747324-8d85c240-3e5d-4ed6-a5b7-4f147b890820.png)

- Configure Load Balancer
![Screenshot from 2022-02-25 02-32-51](https://user-images.githubusercontent.com/80127136/155747526-02fac3f4-9d23-4544-b071-38e4f5113749.png)
- Configure Local DNS Names Relolution
![Screenshot from 2022-02-25 02-49-05](https://user-images.githubusercontent.com/80127136/155747692-903e8b10-7eff-44ec-a412-2c2320dfcd62.png)
![Screenshot from 2022-02-25 02-47-56](https://user-images.githubusercontent.com/80127136/155747721-c218afe2-7bc6-41b8-ae2a-5408cfcea9b9.png)

- Lastly I opened web browser and try to access the ip adress of the load balancer server after running `sudo tail -f /var/log/httpd/access_log` on the two Web Server as shown below:
![Screenshot from 2022-02-25 02-53-15](https://user-images.githubusercontent.com/80127136/155748121-9fdd7d5f-103b-4c48-91c8-01ac17147ae3.png)



Thank You!
