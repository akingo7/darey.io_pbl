# Ansible - Automate Project 7 - 10


### Install and configure Ansible on EC2 instance

- Before starting the project I created my set up with **tilix** to easily navigate between the servers then created six virtual server where two is Ubuntu 20.04 LTS Server for the **Load Balancer Server** and **Ansible-Jenkins Server** where Jenkins for creating a webhook build trigger will stay and ansible that I will use **SSH-Agent** to connect to the other servers and test the ansible play. The other four RHCL 8 are for **2 Webserver**, **Database Server** and **NFS Server**.
![Screenshot from 2022-02-28 20-55-01](https://user-images.githubusercontent.com/80127136/156161714-ef787b7a-9667-42b4-9afe-2e5cc9d7eab8.png)
![Screenshot from 2022-02-28 21-39-23](https://user-images.githubusercontent.com/80127136/156161786-870a741b-3dd7-4b2c-b8ab-54f4ba3f7317.png)
![Screenshot from 2022-02-28 21-50-15](https://user-images.githubusercontent.com/80127136/156161881-f1bcd3c5-dcb6-4b91-b2e8-f7d8531374d6.png)


- I then created port 8080 in the **Ansible-Jenkins Server** security inbound rule.
![Screenshot from 2022-02-28 21-41-46](https://user-images.githubusercontent.com/80127136/156161809-c516e425-c95b-48e8-873b-b2413ee1745d.png)


- Install ansible, jdk and jenkins
![Screenshot from 2022-02-28 21-50-44](https://user-images.githubusercontent.com/80127136/156161898-696dbed6-4de6-4cdb-a39d-356dce208c4a.png)
![Screenshot from 2022-02-28 21-51-26](https://user-images.githubusercontent.com/80127136/156161919-83af42fa-c63b-468e-bd0c-4ade199899ec.png)
![Screenshot from 2022-02-28 21-54-00](https://user-images.githubusercontent.com/80127136/156161927-7a4efe5b-7483-45a0-a913-ee57c2902edd.png)
![Screenshot from 2022-02-28 21-56-40](https://user-images.githubusercontent.com/80127136/156162018-3ef22433-e25b-4069-852a-3a4079bcb8a9.png)
![Screenshot from 2022-02-28 21-57-13](https://user-images.githubusercontent.com/80127136/156162029-210c286e-b9ba-4650-8359-ac0a31b57539.png)


- Created a new repository in my github account then add webhook.
![Screenshot from 2022-02-28 21-57-37](https://user-images.githubusercontent.com/80127136/156162061-19f29656-5a20-48b2-bbd9-8456cbb0b93b.png)
![Screenshot from 2022-02-28 22-01-19](https://user-images.githubusercontent.com/80127136/156162071-38ce9385-5e24-4d48-9d95-20617cb703a9.png)


- Configure a freestyle project **ansible** on my jenkins after setting it up. I faced some error when building the project which is because master branch is't on my github repo but main branch and I forgot to use the json file on my github-webhook editing and in the URL github will push to.
![Screenshot from 2022-02-28 22-01-46](https://user-images.githubusercontent.com/80127136/156162154-e1b37d87-5d5c-4335-8a11-dbdcbe28589b.png)
![Screenshot from 2022-02-28 22-14-40](https://user-images.githubusercontent.com/80127136/156162274-39eec781-2cdb-414b-b738-ac33f0429267.png)


![Screenshot from 2022-02-28 22-20-38](https://user-images.githubusercontent.com/80127136/156162539-93d5d9df-0183-43ed-871d-920fb257989e.png)
![Screenshot from 2022-02-28 22-22-10](https://user-images.githubusercontent.com/80127136/156172326-517f8768-3df9-4b32-aae9-1b71117eb70b.png)
![Screenshot from 2022-02-28 22-23-07](https://user-images.githubusercontent.com/80127136/156172353-f08febd0-17c5-4672-87e3-21f5a08b3c71.png)
![Screenshot from 2022-02-28 22-25-18](https://user-images.githubusercontent.com/80127136/156172369-3e08dccb-c7e4-4b75-aa8d-bd0f07f85a13.png)
![Screenshot from 2022-02-28 22-25-26](https://user-images.githubusercontent.com/80127136/156172375-9ee9f5ad-b83a-4a5d-9b81-727add9196a2.png)
![Screenshot from 2022-02-28 22-25-32](https://user-images.githubusercontent.com/80127136/156172388-2212b186-64ce-4369-b339-50c832bcd40c.png)
![Screenshot from 2022-02-28 22-34-44](https://user-images.githubusercontent.com/80127136/156172416-12c0670b-2534-40ea-9a50-4f9a7ea4ce85.png)

- Then I created an elastic-IP address to have a static public IP for the **Ansible-Jenkins Server**. This stopped the coonection to the Server because I have connected to it before attaching elastic Ip to it.
![Screenshot from 2022-02-28 22-08-39](https://user-images.githubusercontent.com/80127136/156162204-17b93394-0c7b-4b2a-a1cf-3f215c92db3d.png)


- The I configured the jenkins to Archive the Post-build file build trigger after solving the error messages I am getting when I try to build the job. Then edited the README.md file on my repository so see the if I configure the webhook well which I did several times before getting what I want because of the mistake I made which is very good because I learnt a lot from it. 

![Screenshot from 2022-02-28 22-35-37](https://user-images.githubusercontent.com/80127136/156172543-1bcf481e-3c33-40ed-9315-e4f91e97b260.png)

![Screenshot from 2022-02-28 22-40-36](https://user-images.githubusercontent.com/80127136/156172566-4035f96b-fc65-4aa6-b908-73aaa081eeef.png)

![Screenshot from 2022-02-28 22-53-21](https://user-images.githubusercontent.com/80127136/156172580-e88a0bc4-92c5-4a61-b6ab-4e17e14bcd8b.png)

![Screenshot from 2022-02-28 22-54-54](https://user-images.githubusercontent.com/80127136/156172587-c0bab083-6536-46a3-a393-33fce94c7789.png)

![Screenshot from 2022-02-28 23-04-56](https://user-images.githubusercontent.com/80127136/156172605-7801cac5-f89a-4e5d-a5d0-3a3be52d2e3d.png)
![Screenshot from 2022-02-28 23-10-18](https://user-images.githubusercontent.com/80127136/156172611-fced3098-e8bd-4b6d-b76c-d56d0d72df56.png)
![Screenshot from 2022-02-28 23-10-18](https://user-images.githubusercontent.com/80127136/156174107-42e03407-f941-4d4f-98d7-b1c21f08fa57.png)
![Screenshot from 2022-02-28 23-12-53](https://user-images.githubusercontent.com/80127136/156174134-9fc18a4a-9ba7-41ce-bef3-352bdea4e448.png)

![Screenshot from 2022-02-28 23-22-03](https://user-images.githubusercontent.com/80127136/156174270-c9d39853-04a4-4ec6-ad0a-ce1d7e058a39.png)

### Prepare your development environment using Visual Studio Code
- Then I connected my VSCode with the repository which is already installed and configured.

![Screenshot from 2022-02-28 23-31-44](https://user-images.githubusercontent.com/80127136/156174294-348ab920-e4dd-47b6-808e-46c27979a6bb.png)
![Screenshot from 2022-02-28 23-31-49](https://user-images.githubusercontent.com/80127136/156174308-cd54239b-0616-4c11-8a56-4348955072cd.png)


### Begin Ansible Development
- Then I created Directory named *Inventory* and *Playbook*. In the inventory directory I created four files namely Develpment.yml, Testing.yml, Staging.yml and Production.yml then in the Playbook Directory I created a file common.yml.
![Screenshot from 2022-02-28 23-38-07](https://user-images.githubusercontent.com/80127136/156174325-534d2222-72b1-4bdd-b0e9-f2161f361953.png)


### Set up an Ansible Inventory
- Then wrote in inventory file **Developer.yml**, which contains the private IP address of 5 and the username(ssh_virtual machine I want to run task on in my playbook.
![Screenshot from 2022-03-01 00-16-13](https://user-images.githubusercontent.com/80127136/156174993-9e5dddf4-744c-463e-8853-725428854127.png)
![Screenshot from 2022-03-01 00-20-58](https://user-images.githubusercontent.com/80127136/156175194-d78c7fe1-75c3-4685-9070-65959f2026fc.png)

- Then I logout of the **Ansible-Jenkins Server** and added my public key to SSH-agent which is on my localhost.

![Screenshot from 2022-02-28 23-43-50](https://user-images.githubusercontent.com/80127136/156174942-8934164e-26e2-4526-a6b6-7d37190b836d.png)
![Screenshot from 2022-02-28 23-45-51](https://user-images.githubusercontent.com/80127136/156174958-9991f44f-7435-4a92-a353-131222c352ee.png)
![Screenshot from 2022-03-01 00-30-46](https://user-images.githubusercontent.com/80127136/156175231-3b34aabc-b293-4404-9b26-5dc4fc700eb4.png)

- Then I login to my **Ansible-Jenkins Server** using SSH-Agent which will create channel for the localhost SSH signature.
![Screenshot from 2022-03-01 02-06-13](https://user-images.githubusercontent.com/80127136/156175435-62d27c39-a19b-4538-92f6-6a28ac7a5366.png)


### Create A Common Playbook
- Then I wrote ansible playbook in common.yml file to install wireshark on the RHCL 8 using yum and update-cache and install wireshark on the ubuntu server which is the loadbalancer.
- Added some tasks to the playbook to check if SSH service is running on the loadbalancer.
- Then I commit the change on the new branch which is **prj-11** move to my github account to review the playbook and inventory file to see if there is any mistake in the playbook and the inventory file which I had to make several changes on the file commit and marge it with the master branch that I rename my main into.
- After marging the repository with the master branch the Jenkins project received the signal, build and achive the files in my master repo.
### Run Ansible Playbook
- Then I tried to run the ansible playbook I got some error messages which I move to my vscode, check the code again made some changes in the inventory and playbook file. Then I marge the code to the master branch run the new achive file in the playbook and I got another error which made me to review, marge and run the playbook.
After doing that 3 to 4 times I realized the I have to input "yes" to add the signature of the server in the inventory file and my playbook run successfully except for the host that I added wrong command usage in the playbook.

![Screenshot from 2022-03-01 01-03-58](https://user-images.githubusercontent.com/80127136/156175302-3c5f18d1-bba8-4208-8adc-ff7f1aaefe67.png)
![Screenshot from 2022-03-01 01-25-36](https://user-images.githubusercontent.com/80127136/156175319-dbeee94d-6358-4017-98b4-8a6c0f35df36.png)
![Screenshot from 2022-03-01 01-39-25](https://user-images.githubusercontent.com/80127136/156175338-4ee04235-2863-4b53-8c77-3ba8bd024d40.png)
![Screenshot from 2022-03-01 01-39-38](https://user-images.githubusercontent.com/80127136/156175356-ecc30eb0-17b4-4ba0-ab64-1221cad7ed8d.png)

- Then I went to each of the server from one server to another to check if wireshark is the by checking the version and using `which command` which is very interesting and easy to move from one server to another without adding the private key to connection only by adding the flag `-A`.
![Screenshot from 2022-03-01 02-15-39](https://user-images.githubusercontent.com/80127136/156175513-de49510b-7e2f-4757-bc6c-10d2ad66bba8.png)
![Screenshot from 2022-03-01 02-17-42](https://user-images.githubusercontent.com/80127136/156175528-3b023624-7494-437a-b649-e39988d5fe3f.png)
![Screenshot from 2022-03-01 02-22-39](https://user-images.githubusercontent.com/80127136/156175564-7830fa39-f860-45d9-9003-e1a856106b9a.png)
![Screenshot from 2022-03-01 02-25-01](https://user-images.githubusercontent.com/80127136/156175598-bc1943c0-ebf1-487f-8158-2bc6e957bd30.png)
- Then I exit and close the ec2 instances
![Screenshot from 2022-03-01 02-28-27](https://user-images.githubusercontent.com/80127136/156175653-63ee7bba-a7a2-4789-a4a1-cd10b2a7dcb0.png)


Thank You



