# Ansible - Automate Project 7 - 10


### Install and configure Ansible on EC2 instance

- Before starting the project I created my set up with **tilix** to easily navigate between the servers then created six virtual server where two is Ubuntu 20.04 LTS Server for the **Load Balancer Server** and **Ansible-Jenkins Server** where Jenkins for creating a webhook build trigger will stay and ansible that I will use **SSH-Agent** to connect to the other servers and test the ansible play. The other four RHCL 8 are for **2 Webserver**, **Database Server** and **NFS Server**.
- I then created port 8080 in the **Ansible-Jenkins Server** security inbound rule.
- Install ansible, jdk and jenkins
- Created a new repository in my github account then add webhook.
- Configure a freestyle project **ansible** on my jenkins after setting it up. I faced some error when building the project which is because master branch is't on my github repo but main branch and I forgot to use the json file on my github-webhook editing and in the URL github will push to.
- Then I created an elastic-IP address to have a static public IP for the **Ansible-Jenkins Server**. This stopped the coonection to the Server because I have connected to it before attaching elastic Ip to it.
- The I configured the jenkins to Archive the Post-build file build trigger after solving the error messages I am getting when I try to build the job. Then edited the README.md file on my repository so see the if I configure the webhook well which I did several times before getting what I want because of the mistake I made which is very good because I learnt a lot from it. 
### Prepare your development environment using Visual Studio Code
- Then I connected my VSCode with the repository which is already installed and configured.
### Begin Ansible Development
- Then I created Directory named *Inventory* and *Playbook*. In the inventory directory I created four files namely Develpment.yml, Testing.yml, Staging.yml and Production.yml then in the Playbook Directory I created a file common.yml.
### Set up an Ansible Inventory
- Then wrote in inventory file **Developer.yml**, which contains the private IP address of 5 and the username(ssh_virtual machine I want to run task on in my playbook.
- Then I logout of the **Ansible-Jenkins Server** and added my public key to SSH-agent which is on my localhost.
- Then I login to my **Ansible-Jenkins Server** using SSH-Agent which will create channel for the localhost SSH signature.
### Create A Common Playbook
- Then I wrote ansible playbook in common.yml file to install wireshark on the RHCL 8 using yum and update-cache and install wireshark on the ubuntu server which is the loadbalancer.
- Added some tasks to the playbook to check if SSH service is running on the loadbalancer.
- Then I commit the change on the new branch which is **prj-11** move to my github account to review the playbook and inventory file to see if there is any mistake in the playbook and the inventory file which I had to make several changes on the file commit and marge it with the master branch that I rename my main into.
- After marging the repository with the master branch the Jenkins project received the signal, build and achive the files in my master repo.
### Run Ansible Playbook
- Then I tried to run the ansible playbook I got some error messages which I move to my vscode, check the code again made some changes in the inventory and playbook file. Then I marge the code to the master branch run the new achive file in the playbook and I got another error which made me to review, marge and run the playbook.    
After doing that 3 to 4 times I realized the I have to input "yes" to add the signature of the server in the inventory file and my playbook run successfully except for the host that I added wrong command usage in the playbook.
- Then I went to each of the server from one server to another to check if wireshark is the by checking the version and using `which command` which is very interesting and easy to move from one server to another without adding the private key to connection only by adding the flag `-A`.

Thank You



