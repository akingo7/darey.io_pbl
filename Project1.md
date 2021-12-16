# WEB STACK IMPLIMENTATION USING AWS

Software Development Life Cycle(SDLC): This is the process used in software industry that include planning, designing, developing, testing, deploying and mentainace of a software.

Software Development Life Cycle (SDLC) is a process used by the software industry to design, develop and test high quality softwares. The SDLC aims to produce a high-quality software that meets or exceeds customer expectations, reaches completion within times and cost estimates. **(FROM tutorialspoint.com)**

The new seven phases of SDLC include planning, analysis, design, development, testing, implementation, and maintenance of software **(clouddefence.ai)**.

List of most commonly used ports on web
    HTTP – Port 80
    HTTPS – 443
    FTP – 21
    FTPS / SSH – 22
    POP3 – 110
    POP3 SSL – 995
    IMAP – 143
    IMAP SSL – 993
    SMTP – 25 (Alternate: 26)
    SMTP SSL – 587
    MySQL – 3306
    cPanel – 2082
    cPanel SSL – 2083
    WHM (Webhost Manager) – 2086
    WHM (Webhost Manager) SSL – 2087
    Webmail – 2095
    Webmail SSL – 2096
    WebDAV/WebDisk – 2077
    WebDAV/WebDisk SSL – 2078
    
    ## Images of the Input and the result I got while doing project 1
![Screenshot from 2021-12-14 17-17-21](https://user-images.githubusercontent.com/80127136/146450252-6daad843-4b52-43b8-951f-28bdbd2c7d43.png)
![Screenshot from 2021-12-14 17-26-12](https://user-images.githubusercontent.com/80127136/146450288-497f7c20-e34a-48a5-896b-873dc9a1f43f.png)
![Screenshot from 2021-12-14 17-26-16](https://user-images.githubusercontent.com/80127136/146450319-092f1c06-81fc-460b-9413-9b1a9b782151.png)
![Screenshot from 2021-12-14 17-27-18](https://user-images.gith![Screenshot from 2021-12-14 17-28-26](https://user-images.githubusercontent.com/80127136/146450348-631f8222-1e20-4c45-8146-aed86ac531b1.png)
ubusercontent.com/80127136/146450321-a406fb2f-f96f-47c4-9677-bf06e268![Screenshot from 2021-12-14 17-29-56](https://user-images.githubusercontent.com/80127136/146450372-b016bddc-971c-42e7-b865-680a27985124.png)![Screenshot from 2021-12-14 17-33-35](https://user-images.githubusercontent.com/80127136/146450379-c6e71e12-530d-4e6e-928d-eac5058e73b9.png)

627b.png)
![Screenshot from 2021-12-14 17-34-05](https://user-images.githubusercontent.com/80127136/146450399-338bb463-78d9-41d8-8654-8d77ea7e3565.png)
![Screenshot from 2021-12-14 17-38-58](https://user-images.githubusercontent.com/80127136/146450415-02af282a-b33d-405c-8960-1301db3e4a6b.png)![Screenshot from 2021-12-14 17-39-06](https://user-images.githubusercontent.com/80127136/146450418-786f4933-83d5-4d0c-be47-a60ff99b5224.png)

![Screenshot from 2021-12-14 17-41-42](https://user-images.github![Screenshot from 2021-12-14 17-43-14](https://user-images.githubusercontent.com/80127136/146450450-c6eca457-a818-4d61-b379-35fbe5185b64.png)
usercontent.com/80127136/146450434-fa66df0d-ae2b-47b5-83c3![Screenshot ![Screenshot from 2021-12-14 18-45-41](https://user-images.githubusercontent.com/80127136/146450474-fd9f5f64-253c-4048-9c5c-fa529ed963d9.png)
from 2021-12-14 18-05-16](https://user-images.githubusercontent.com/80127136/146450467-b0dd8c90-b698-4107-9ca2-0b1f28c4308f.png)
-fb40436f1c74.png)
![Screenshot from 2021-12-16 20-51-58](https://user-images.githubuse![Screenshot from 2021-12-16 20-54-08](https://user-images.githubusercontent.com/80127136/146450509-8b4475b3-29d4-4c77-bd82-dfb262c11400.png)
rcontent.com/80127136/146450499-84122b25-f979-4cb6-aa89-5d524e1d8c56.png)
![Screenshot from 2021-12-16 20-57-59](https://user-images.githubusercontent.com/80127136/146450544-1efe3d50-f080-42aa-a4bd-25acc00bc50f.png)
![Screenshot from 2021-12-16 21-01-03](https://user-images.githubusercontent.com/80127136/146450558-8dc2ee86-be98-437c-891d-f7207195d880.png)![Screenshot from 2021-12-16 21-01-58](https://user-images.githubusercontent.com/80127136/146450557-5de6d3bb-338d-4fa4-a233-c7dd32c22295.png)

![Screenshot from 2021-12-16 21-08-17](https://user-images.githubusercontent.com/80127136/146450575-69c63a5d-7475-423f-a964-cfc89d54cc69.png)
![Screenshot from 2021-12-16 21-37-28](https://user-image![Screenshot from 2021-12-16 21-41-03](https://user-images.githubusercontent.com/80127136/146450611-7d486cde-9af4-46c7-a0f8-a38501150fd1.png)
s.githubusercontent.com/80127136/146450590-d6ae0ee4-74e1-460c-9897-deea6a760ed2.png)
![Screenshot from 2021-12-16 21-41-16](https://user-images.githubusercontent.com/80127136/146450651-17509176-cf8e-4938-b3a8-6fe972e3c005.png)


## Steps
- I downloaded the pem file from AWS which is the private key to access the instance which I saved as "mykey", then set the machine to listen to port 22 and 80 which are the port for SSH and HTTP respectively.
- Then I change the file permission of the pem file to allow only root to read (0400) and connected to the server with the command `ssh -i "mykey" ubuntu@hostname`
- Then I installed the required tool which include MYSQL as the database, PHP to load the content on the site which will run on the server and Apache2 to host the website with `apt`(advance package tool) command.
- Then I install php-mysql and libapache2-mod-php which will make the tools to communicate with each other.
- I tested the apache my checking the default apache page my website
- Then I created projectlamp directory in /var/www and configure it to use virtualhost.
- Rearranged the order of the index for apache and placed php first and created a php file, reboot the apache then check the website on browser which show the information about my pc and connection settings, etc.

This project is created on Ubuntu as the Virtual Server host on AWS and as my local host.






Gabriel Akinmoyero
- 
