#Project 5 Client-Server Implementation Using Mysql DBMS

This project is used to implement client-server achitecture. To connect to mysql server from another machine in which mysql-client is installed on

The first step is to install mysql-server and mysql-client on each of the machine(instance) which I will launch from Amazon Web Service ec2 and use Ubuntu 20.04 which is part of the free tier on AWS.
Then I ran the command mysql_secure_installation to further sercure the mysql-server

![Screenshot from 2022-01-14 04-52-33](https://user-images.githubusercontent.com/80127136/149595446-223cfcb7-7bd3-4603-a8e2-a316a7b229a7.png)

![Screenshot from 2022-01-14 04-47-55](https://user-images.githubusercontent.com/80127136/149595381-7de0b36b-16b5-40de-8721-533f85a485f4.png)
![Screenshot from 2022-01-14 04-50-08](https://user-images.githubusercontent.com/80127136/149595428-643a6a8b-20b5-4e8a-86d4-5d8b446c8f79.png)
 
 Then I edited the file /etc/mysql/mysql.conf.d/mysqld.cnf bind to allow connection from anywhere and also edited the inbound rule on my aws to allow only the client machine to connect to port 3306 which is the port mysql listen to. Then I created user "gabriel" which is my name and granted the user full priviledge to the database Newdb.
 I logged in to mysql server from the client machine using mysql command with the user, ip address, and password of the user created on the server. 
 
 ![Screenshot from 2022-01-14 05-00-57](https://user-images.githubusercontent.com/80127136/149596151-5624184d-dd97-4549-b97b-92519c6f9f04.png)

 ![Screenshot from 2022-01-14 22-47-05](https://user-images.githubusercontent.com/80127136/149596159-3f9262f2-259d-4c36-913d-4fdf1091cf6a.png)

 ![Screenshot from 2022-01-14 22-48-07](https://user-images.githubusercontent.com/80127136/149596164-9357fedb-d11a-4198-8447-6ec90e4b0de4.png)

 ![Screenshot from 2022-01-14 23-25-18](https://user-images.githubusercontent.com/80127136/149596174-fe65ef41-fe2e-4df8-8921-bb582f89f5fd.png)
 
![Screenshot from 2022-01-14 23-25-58](https://user-images.githubusercontent.com/80127136/149596230-23aeca87-cfaf-49f9-b187-8a11cbe69638.png)

 Thank you for reading.
 Gabriel Akinmoyero
