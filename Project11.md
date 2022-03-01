# Ansible - Automate Project 7 - 10


### Install and configure Ansible on EC2 instance

- Before starting the project I created my set up with **tilix** to easily navigate between the servers then created six virtual server where two is Ubuntu 20.04 LTS Server for the **Load Balancer Server** and **Ansible-Jenkins Server** where Jenkins for creating a webhook build trigger will stay and ansible that I will use **SSH-Agent** to connect to the other servers and test the ansible play. The other four RHCL 8 are for **2 Webserver**, **Database Server** and **NFS Server**.
- I then created port 8080 in the **Ansible-Jenkins Server** security inbound rule.
- Install ansible, jdk and jenkins
- Created a new repository in my github account then add webhook.
- Configure a freestyle project **ansible** on my jenkins after setting it up. I faced some error when building the project which is because master branch is't on my github repo but main branch and I forgot to use the json file on my github-webhook editing and in the URL github will push to.
- Then I created an elastic-IP address to have a static public IP for the **Ansible-Jenkins Server**. This stopped the coonection to the Server because I have connected to it before attaching elastic Ip to it.
- The I configured the jenkins to Archive the Post-build file build trigger after solving the error messages I am getting when I try to build the job. Then edited the README.md file on my repository so see the if I configure the webhook well which I did several times before getting what I want because of the mistake I made which is very good because I learnt a lot from it. 
- 