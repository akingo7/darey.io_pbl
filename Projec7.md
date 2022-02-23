# DEVOPS WEBSITE TOOLING SOLUTION 

### Step 1 - Prepare NFS Server & Step 2 - Configure The Database Server

I created three volumes of 10Gig each on AWS then attach it to the Network FileSystem Server(EC2 instance with RHEL Linux 8 Operating System) after setting up my terminal using tilix.
![Screenshot from 2022-02-22 19-10-45](https://user-images.githubusercontent.com/80127136/155307477-305e1b80-2ccc-4691-95b2-69e82d74de27.png)

I then connect to my NFS Server and Database Server(Ubuntu 20.04)
Update and Install MySQL server in the Database server using
> `sudo apt update`   
> `sudo apt install mysql-server`


Then I install lvm2 on the NFS with `sudo yum install lvm2` to create logical volume, created partition using `gdisk` with Linux LV(8e00) partition type on the 10G volumes attached to NFS Server.   
Then I created physical volume with the command `pvcreate` using the Linux LVM partition created, add all the partition to volume group "volg" then using the volume group I created three logical volume with the command `lvcreate` which include lv-apps, lv-logs and lv-opt. Format the three logical volumes created  with 'xfs' using the command `sudo mkfs.xfs /dev/volg/lv-apps /dev/volg/lv-logs /dev/volg/opt` then create and mount the logical volumes on the directory /mnt/apps, /mnt/logs and /mnt/opt respectively. After that I mounted the logical volumes with the UUID  to the respective paths in the file /etc/fstab so that logical volumes with me mounted automatically when the machine is booted.
![Screenshot from 2022-02-22 19-17-04](https://user-images.githubusercontent.com/80127136/155311546-d032b167-8322-4441-9d6d-203edf237626.png)
![Screenshot from 2022-02-22 19-19-30](https://user-images.githubusercontent.com/80127136/155311559-9715e5df-f494-40be-b6e9-e86e8436ef93.png)
![Screenshot from 2022-02-22 19-24-50](https://user-images.githubusercontent.com/80127136/155311569-08fcd591-eebf-4501-8160-0271fcf58206.png)
![Screenshot from 2022-02-22 19-28-27](https://user-images.githubusercontent.com/80127136/155311582-b2bb2a52-7a81-4d73-8bbf-ca4960e6652f.png)
![Screenshot from 2022-02-22 19-41-08](https://user-images.githubusercontent.com/80127136/155311623-03d58ebf-1bea-4cf2-8f66-a605533b2b4f.png)

Then I run the command `sudo mount -a` to ensure that I mounted the logical volume correctly which can prevent the machine from booting if not taken care of.
![Screenshot from 2022-02-22 19-45-41](https://user-images.githubusercontent.com/80127136/155312365-aba4f5be-88fa-4ffc-b57d-71f0549b77eb.png)

On the Database server I created Database **tooling**, created user **webaccess** with **password('password')** which can be accessed from the subnet ip and grant all privileges on Database **tooling** to the user **webaccess**
![Screenshot from 2022-02-22 19-54-38](https://user-images.githubusercontent.com/80127136/155312956-9945ce79-bdec-47cf-ba79-b5a6fbaca183.png)
![Screenshot from 2022-02-22 19-59-25](https://user-images.githubusercontent.com/80127136/155312965-31828cac-8d06-4592-8e30-a3596bb1bdb9.png)

Moving to the NFS server I installed "nfs-utils" after updating which will be used to server the file system, enable the service on boot and state the service using the command
`sudo yum -y update   
sudo yum install nfs-utils -y   
sudo systemctl start nfs-server.service   
sudo systemctl enable nfs-server.service   
sudo systemctl status nfs-server.service`
![Screenshot from 2022-02-22 20-05-03](https://user-images.githubusercontent.com/80127136/155313597-eb33149d-88f1-4627-9448-ccb2592fcbba.png)

I changed the ownership and permission of the /mnt/apps, /mnt/opt and /mnt/logs to nobody and can be accessed by anybody, then I restart the server.   
Then I configure access to NFS for clients within the same subnet (example of Subnet CIDR – 172.31.32.0/20 ) with the file /etc/exports by adding the following to the file:
`/mnt/apps 172.31.32.0/20(rw,sync,no_all_squash,no_root_squash)   
/mnt/logs 172.31.32.0/20(rw,sync,no_all_squash,no_root_squash)   
/mnt/opt 172.31.32.0/20(rw,sync,no_all_squash,no_root_squash)   `

Then export the directory in /mnt with the command `sudo exportfs -arv`
![Screenshot from 2022-02-22 20-12-11](https://user-images.githubusercontent.com/80127136/155315551-3eaffc38-9f07-4758-a403-e7aa2d3c622b.png)

Edit inbound security of the NFS server to listen to ports: TCP 111, UDP 111, UDP 2049.
![Screenshot from 2022-02-22 20-15-03](https://user-images.githubusercontent.com/80127136/155316458-80e2b9df-515d-4915-b1cd-917201a3dd08.png)




### Step 3 - Prepare The Webserver

I launch new EC2 instance with RHEL 8 Operating System and connect to it then download NFS client on it. After that I created directory /var/www then mount the nfs server's /mnt/apps on it:
`sudo mkdir /var/www   
sudo mount -t nfs -o rw,nosuid 172.31.32.0/20:/mnt/apps /var/www`
![Screenshot from 2022-02-22 20-48-38](https://user-images.githubusercontent.com/80127136/155317234-cfbc6e27-ff0f-495f-97b7-4eb75d3ca874.png)

Which didn't work because I didn't copy the private ip address instead I copied the public ip address and I started troubleshooting that for like three hours. After mounting it I run `df -h` to see if it's successful then I mounted it on /etc/fstab to make sure that the changes will persist on Web Server after booting.
 ![Screenshot from 2022-02-23 00-24-58](https://user-images.githubusercontent.com/80127136/155319733-8ae67139-b955-4471-8537-143300280073.png)
![Screenshot from 2022-02-23 00-29-15](https://user-images.githubusercontent.com/80127136/155319823-a617fe91-cd58-4f31-a706-73fbbbc94d89.png)
![Screenshot from 2022-02-23 00-31-54](https://user-images.githubusercontent.com/80127136/155319873-96273b88-93b5-47a0-bc05-82ddf9de52e3.png)


Then I Install Remi’s repository, Apache and PHP
`sudo yum install httpd -y   

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm   

sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm   

sudo dnf module reset php   

sudo dnf module enable php:remi-7.4   

sudo dnf install php php-opcache php-gd php-curl php-mysqlnd   

sudo systemctl start php-fpm   

sudo systemctl enable php-fpm   

setsebool -P httpd_execmem 1`
 Then I repeat the steps under above for another 2 webserver

![Screenshot from 2022-02-23 00-41-29](https://user-images.githubusercontent.com/80127136/155319967-97463ffe-3c5c-4652-9db4-c46799a768d3.png)
![Screenshot from 2022-02-23 00-44-36](https://user-images.githubusercontent.com/80127136/155319989-3a874d1a-6ebb-49b8-aef3-bf5c582a0dad.png)

Then I fork the repo in the documentation moved all that is in html to /var/www/html, open inbound rule on webserver and database server to listen to httpd( port 80 ) and mysql respectively. Did some other things like configuring the mysql username, password, host, and database name on the file `function.php`, running the file tooling-db.sql on the webserver, editing bind address in the database server and restarting it then the website is up and running.
![Screenshot from 2022-02-23 02-31-06](https://user-images.githubusercontent.com/80127136/155321884-5cf00c7e-88b6-4e9e-b519-736e2c37b371.png)
![Screenshot from 2022-02-23 02-35-17](https://user-images.githubusercontent.com/80127136/155321924-5d40316b-a676-4291-b0ba-60ddfdca015c.png)
![Screenshot from 2022-02-23 02-37-22](https://user-images.githubusercontent.com/80127136/155321936-a2b49e48-9499-43fe-a288-6a77a3a2d3fe.png)




Thank you for reading.


