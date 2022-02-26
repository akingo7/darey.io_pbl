# CONTINOUS INTEGRATION PIPELINE FOR TOOLING WEBSITE

### Install and Configure Jenkins

- After launching an Ubuntu 20.04 LTS, I added the **port 8080** in the inbount rule 
![Screenshot from 2022-02-25 19-30-27](https://user-images.githubusercontent.com/80127136/155808728-7cb1d396-a71f-4629-8846-71853ea91772.png)

- Then I connect to the server and update apt after that I installed JDK with `sudo apt install default-jdk-headless`
![Screenshot from 2022-02-25 19-31-37](https://user-images.githubusercontent.com/80127136/155809892-2c99021a-40f2-4f5c-8dee-9172204ed126.png)

- Install Jenkins with:
`wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt-get install jenkins`
![Screenshot from 2022-02-25 19-35-51](https://user-images.githubusercontent.com/80127136/155810092-9515b5b9-e59d-42b1-9b9e-6a7865ae6825.png)

- Then I checked the status of jenkins to know if it's running
![Screenshot from 2022-02-25 19-38-18](https://user-images.githubusercontent.com/80127136/155810156-c66ac277-74fb-4387-ac3e-8ffcdb921872.png)

- Then I opened jenkins UI on my browser with <public_ip_address>:8080, copied the default admin password from /var/lib/jenkins/secrets/initialAdminPassword 
![Screenshot from 2022-02-25 19-42-05](https://user-images.githubusercontent.com/80127136/155810528-2bb2011d-052c-43b3-b8f8-ccf3c92737f6.png)

- Installed Jenkins suggested plugins
- ![Screenshot from 2022-02-25 19-42-26](https://user-images.githubusercontent.com/80127136/155810680-6f3e6be4-94bc-4099-a261-18244f5cf6ad.png)

### Configure Jenkins to retrieve source codes from GitHub using Webhooks
- I enabled webhooks in my GitHub repository setting 
![Screenshot from 2022-02-25 19-41-09](https://user-images.githubusercontent.com/80127136/155817614-13d00336-1859-4328-927c-0a257597894a.png)

- Then I click on **New Item** and created a **Freestyle project**, copy and paste the repository URL to connect to GitHub from Jenkins.
![Screenshot from 2022-02-25 19-46-22](https://user-images.githubusercontent.com/80127136/155817832-b99ab19f-943a-4002-b5bf-3c8ec4f972d3.png)
![Screenshot from 2022-02-25 19-47-30](https://user-images.githubusercontent.com/80127136/155818203-2f0c458e-1648-4bc6-b6df-f85c3a2f3cd6.png)

- Save and Build the project
![Screenshot from 2022-02-25 19-48-16](https://user-images.githubusercontent.com/80127136/155818267-5dab2c0e-7797-4da6-8912-e11583c18e72.png)

- Then I configured the project
- Configure triggering the job from GitHub webhook
![Screenshot from 2022-02-25 19-50-01](https://user-images.githubusercontent.com/80127136/155818742-95ec1f02-00aa-47f5-ab36-5fef3c2bd9ce.png)

- Configure "Post-build Actions" to archive all the files
![Screenshot from 2022-02-25 19-50-04](https://user-images.githubusercontent.com/80127136/155818850-f07a4d33-5232-4777-922a-cacd7646a4b7.png)

- Then I save the file, move to my GitHub account edit and commit changes on the README.md file which the Jenkins automatically build the project and achive the files 
![Screenshot from 2022-02-25 19-55-23](https://user-images.githubusercontent.com/80127136/155819039-632f7722-0fec-43ff-87f8-d2ba1066d780.png)
![Screenshot from 2022-02-25 19-59-38](https://user-images.githubusercontent.com/80127136/155819048-1438746c-e701-43dd-a930-ad9177ba9b73.png)


Thank You!


