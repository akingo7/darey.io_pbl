# AWS CLOUD SOLUTION FOR 2 COMPANY WEBSITES USING A REVERSE PROXY TECHNOLOGY

### AWS Cloud Project

- I created Organization in my AWS Account. Created Organization Unit named "Dev" Then I added a new account to the organization with the name DevOps which I created with another email address which I used for this project and moved the new account "DevOps" to Dev organization unit.

- I created a free Domain Name ("gabrieldevops.ml") from freenom.com, created aws hosted zone then map the nameserver from freenom to AWS hosted zone so that I can use aws as the Domain name server.

- I then requested for certificate for the domain name with Amazon Certificate Manager

### Set up Virtual Private Network (VPC)

- I created a VPC with CIDR 10.0.0.0/16, in the VPC I created 6 subnets in two different AZ, 3 in each AZ with subnet IP range 251 for each.

- Then I created Internet Gateway and attach it to my VPC. Created three Route table and attach one to two subnets each.

- For the Public Subnet I edited the Network Access Control List (NACL) then set the target to Internet Gateway If the destination is from anywhere.

- Then I created a NAT Gateway with elastic IP which the private subnet will be using to connect with the internet and edited one of the route table attached to NACL to target NAT Gateway if the private subnet destination is to anywhere.

- Then I created security group that I will attach to each of the target group. Nginx security group that will listen to only the Internet Facing Application Load Balancer (ALP) on port 80 and 443, ssh connecting from bastion server. Bastion Security Group that allow ssh connection from my IP only. ALB which will allow http and https connection from IP. Internal ALB which will allow http connection from nginx. Webservers Security Group to allow http connection from Internal ALB. Database Security Group which will allow connection from Webservers.

- I created one instance each for the Bastion Server, Nginx Server for reverse proxy, Tooling Webserver to serve the tooling source code from github and Wordpress then installed all the necessary software and ensure that it's working as expected. Ensured that `python ntp net-tools vim wget telnet epel-release htop` are installed on the bastion server and nginx.

- I created Amazon FileSystem (EFS) and Amazon Relational Services (RDS) then I mounted the EFS on the Webservers which I used for the Launch Configuration. 

- Then I created Target Group for Nginx Reverse Proxy, Wordpress WebServer and Tooling Webserver. I changed the health check status to 302 after running `curl -I IP` to check the health status.

- Then I created Internal Application Load Balancer which I edited the rules to map to wordpress target group if the host address is "www.gabrieldevops.ml" or "gabrieldevops.ml" then if the host address is "tooling.gabrieldevops.ml" it should map to the tooling target group on port 80.

- Created Internet Facing Application Load Balancer with nginx reverse proxy as the target group which is listening on port 443 and 80. 


- I then created autoscaling group for Bastion Server, Nginx Server, Tooling Webserver and Wordpress Webserver in the two AZ. The minimum number of instance is 2 , maximum is 2 and the desired is 2 so that I will have only one instance in on AZ.


- I then created three record on route53 for gabrieldevops.ml, www.gabrieldevops.ml and tooling.gabrieldevops.ml. Using alias record, all the host names are mapping to the Internet Facing ALB.

- Then I entered the domain name on my browser to test it.