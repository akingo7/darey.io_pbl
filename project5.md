# Project 5 Client-Server Architecture with MyQL
  ##### This project is created with Ubuntu as host (Server) system and Ubuntu as guest (Client) because I am having some issue with my AWS account.
  ##### After installing AWS account on *Client* and *Server* as you can see in the screenshot below
![Screenshot from 2021-03-09 18-26-30](https://user-images.githubusercontent.com/80127136/114907029-91581180-9e12-11eb-91a4-431fd2dcd932.png)
  ![Screenshot from 2021-03-09 18-30-31](https://user-images.githubusercontent.com/80127136/114906855-64a3fa00-9e12-11eb-8436-fe75857056eb.png)
  
  ##### Then I opened */etc/mysql/mysql.conf.d/mysql.conf* configuration file with VI and then changed the bind address to allow form other computer on the *Server*, as shown below
  ![Screenshot from 2021-03-09 18-47-59](https://user-images.githubusercontent.com/80127136/114907788-59050300-9e13-11eb-95a4-69a9ebf66f1f.png)
![Screenshot from 2021-03-09 18-48-40](https://user-images.githubusercontent.com/80127136/114907803-5d312080-9e13-11eb-9f39-a52d3c298c54.png)
![Screenshot from 2021-03-09 18-51-27](https://user-images.githubusercontent.com/80127136/114908072-a41f1600-9e13-11eb-984b-dc8db7b4eb94.png)



##### Then I was able to connect from the *client* which is the guest OS after allowing IP with Uncomplicated FireWall 
![Screenshot from 2021-04-15 17-16-51](https://user-images.githubusercontent.com/80127136/114908437-011acc00-9e14-11eb-940a-b21a73943fee.png)

  
