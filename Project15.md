# AWS CLOUD SOLUTION FOR 2 COMPANY WEBSITES USING A REVERSE PROXY TECHNOLOGY

### AWS Cloud Project

- I created Organization in my AWS Account. Created Organization Unit named "Dev" Then I added a new account to the organization with the name DevOps which I created with another email address which I used for this project and moved the new account "DevOps" to Dev organization unit.
![Screenshot 2022-03-20 010501](https://user-images.githubusercontent.com/80127136/159383682-e5ede2c4-9c30-43e3-9bc0-41611269c3e8.png)
![Screenshot 2022-03-20 020007](https://user-images.githubusercontent.com/80127136/159383695-51392b34-4fe3-425f-94b3-887aef999a87.png)

- I created a free Domain Name ("gabrieldevops.ml") from freenom.com, created aws hosted zone then map the nameserver from freenom to AWS hosted zone so that I can use aws as the Domain name server.

- I then requested for certificate for the domain name with Amazon Certificate Manager for my domain name.
![Screenshot 2022-03-20 213412](https://user-images.githubusercontent.com/80127136/159384152-b73bf481-1db6-43cd-ba74-aa794a1057c2.png)

### Set up Virtual Private Network (VPC)

- I created a VPC with CIDR 10.0.0.0/16, in the VPC I created 6 subnets in two different AZ, 3 in each AZ with subnet IP range 251 for each.
![Screenshot 2022-03-21 064342](https://user-images.githubusercontent.com/80127136/159384543-1fe0164d-a348-4e6d-a92e-d49465b29fd0.png)

- Then I created Internet Gateway and attach it to my VPC. Created three Route table and attach one to two subnets each.
![Screenshot 2022-03-20 051320](https://user-images.githubusercontent.com/80127136/159383743-4781f6fd-7c85-4cd8-b9d7-8732eb1d8612.png)
![Screenshot 2022-03-21 064310](https://user-images.githubusercontent.com/80127136/159384513-53facc9e-00cc-4972-9e9f-9c7ae8de37b7.png)

![Screenshot 2022-03-21 064215](https://user-images.githubusercontent.com/80127136/159384453-c9a02064-dd7c-4d2f-8bc0-1fdd3704bbc4.png)
![Screenshot 2022-03-21 064235](https://user-images.githubusercontent.com/80127136/159384472-887aabf7-6896-41fd-a0e0-2f49dc81d94b.png)

- For the Public Subnet I edited the Network Access Control List (NACL) then set the target to Internet Gateway If the destination is from anywhere.
![Screenshot 2022-03-20 052047](https://user-images.githubusercontent.com/80127136/159383760-3f94ab05-d1b2-439b-a85c-0a4bf0c630bb.png)

- Then I created a NAT Gateway with elastic IP which the private subnet will be using to connect with the internet and edited one of the route table attached to NACL to target NAT Gateway if the private subnet destination is to anywhere.

- Then I created security group that I will attach to each of the target group. Nginx security group that will listen to only the Internet Facing Application Load Balancer (ALP) on port 80 and 443, ssh connecting from bastion server. Bastion Security Group that allow ssh connection from my IP only. ALB which will allow http and https connection from IP. Internal ALB which will allow http connection from nginx. Webservers Security Group to allow http connection from Internal ALB. Database Security Group which will allow connection from Webservers.

- I created one instance each for the Bastion Server, Nginx Server for reverse proxy, Tooling Webserver to serve the tooling source code from github and Wordpress then installed all the necessary software and ensure that it's working as expected. Ensured that `python ntp net-tools vim wget telnet epel-release htop` are installed on the bastion server and nginx. I changed the nameserver in the file `/etc/resolv.conf` to `10.0.0.2` because the instance isn't resolving host.
![Screenshot 2022-03-20 062045](https://user-images.githubusercontent.com/80127136/159383833-b73443aa-107c-48bb-ba51-609f51bc6d10.png)

- I created Amazon FileSystem (EFS) and MySQl Amazon Relational Services (RDS) then I mounted the EFS on the Webservers which I used for the Launch Configuration. 
![Screenshot 2022-03-20 094251](https://user-images.githubusercontent.com/80127136/159384093-4c176d45-59e4-4674-8a91-f4f823fd4ebd.png)
![Screenshot 2022-03-20 191333](https://user-images.githubusercontent.com/80127136/159384140-2c08f75d-c1ff-43ff-a0c7-c04c7a508e9c.png)
![Screenshot 2022-03-20 220334](https://user-images.githubusercontent.com/80127136/159384218-720d19fc-493b-4b26-9e17-93fb46d47604.png)

- Then I created Target Group for Nginx Reverse Proxy, Wordpress WebServer and Tooling Webserver. I changed the health check status to 302 after running `curl -I IP` to check the health status.

- Then I created Internal Application Load Balancer which I edited the rules to map to wordpress target group if the host address is "www.gabrieldevops.ml" or "gabrieldevops.ml" then if the host address is "tooling.gabrieldevops.ml" it should map to the tooling target group on port 80.
![Screenshot 2022-03-20 233959](https://user-images.githubusercontent.com/80127136/159384307-1be8e661-fe75-47be-b888-222e19902a43.png)

- Created Internet Facing Application Load Balancer with nginx reverse proxy as the target group which is listening on port 443 and 80. 
![Screenshot 2022-03-21 070825](https://user-images.githubusercontent.com/80127136/159384650-7ca91eb5-6bec-4a8c-ad31-6e38820fd89c.png)
![Screenshot 2022-03-21 070900](https://user-images.githubusercontent.com/80127136/159384660-49c5d48b-5ba0-4c5d-bfb0-995d0d38acec.png)


- I then created autoscaling group for Bastion Server, Nginx Server, Tooling Webserver and Wordpress Webserver in the two AZ. The minimum number of instance is 2 , maximum is 2 and the desired is 2 so that I will have only one instance in on AZ.
![Screenshot 2022-03-20 235220](https://user-images.githubusercontent.com/80127136/159384324-a840c2dc-e515-43d7-82ba-27122276ccea.png)
![Screenshot 2022-03-21 012804](https://user-images.githubusercontent.com/80127136/159384338-9c07cd59-2b13-4fc4-b11f-1d0bf5a3d3e5.png)
![Screenshot 2022-03-21 012824](https://user-images.githubusercontent.com/80127136/159384351-8693cc6a-ef90-4faa-acbb-e20b5a09997e.png)


- I then created three record on route53 for gabrieldevops.ml, www.gabrieldevops.ml and tooling.gabrieldevops.ml. Using alias record, all the host names are mapping to the Internet Facing ALB.
![Screenshot 2022-03-21 071019](https://user-images.githubusercontent.com/80127136/159384694-a6e59494-ef55-42ec-a139-9b64693206e6.png)

- Then I entered the domain name on my browser to test it.
![Screenshot 2022-03-21 062157](https://user-images.githubusercontent.com/80127136/159384384-feddf576-f714-4e20-aad3-dd8e2fb1ef7a.png)
![Screenshot 2022-03-21 062353](https://user-images.githubusercontent.com/80127136/159384399-6f12f391-3fda-4b0b-ba27-9592e8bc28b1.png)
![Screenshot 2022-03-21 070342](https://user-images.githubusercontent.com/80127136/159384567-16895ae0-6c48-4392-9f6c-9e602e7068df.png)


