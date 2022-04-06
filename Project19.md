# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 4

## Create a Terraform Cloud Account

- I signed up for Terraform cloud account then verify my mail.

![Screenshot from 2022-04-05 22-44-38](https://user-images.githubusercontent.com/80127136/162086814-d42a2c47-9ddc-44a6-8ba8-9a1d5d9ce8e9.png)

- Created an organization named "gabrieldevops".

![Screenshot from 2022-04-05 22-46-11](https://user-images.githubusercontent.com/80127136/162086829-b994a25a-3b82-46a9-b1b3-4386a41854ff.png)

- Created a github repository then push my terraform codes to the [repository](https://github.com/akingo7/terraform-cloud).

- Configure a workspace with version control workflow then create Terraform Organization Authorization with my github account.

![Screenshot from 2022-04-05 22-46-34](https://user-images.githubusercontent.com/80127136/162087046-28bfbd32-fc34-441c-9f18-3ebf9ace99f2.png)
![Screenshot from 2022-04-05 22-47-13](https://user-images.githubusercontent.com/80127136/162087064-4347950d-17a9-4118-b43b-e166a5b64946.png)
![Screenshot from 2022-04-05 22-55-11](https://user-images.githubusercontent.com/80127136/162087134-34a6472e-bed2-451e-9e35-5c2cad6cdb5d.png)

- Added AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY Environment variable then mark both of them as sensitive.

![Screenshot from 2022-04-05 23-06-04](https://user-images.githubusercontent.com/80127136/162087170-a44b6635-d1bb-415e-a078-c046862ca8f0.png)

- I then used packer to build Ubuntu 20.04 image for nginx, bastion, tooling and wordpress with provisional to run shell script. When I tried to build the image I got an error which is because I used the same source to build 4 images which doesn't work like that. Then I checked [Hashicorp](learn.hashicorp.com/packer) learning site to learn how it works.

![Screenshot from 2022-04-05 17-41-17](https://user-images.githubusercontent.com/80127136/162087242-d5497849-227b-4766-b56a-658a80f9b502.png)
![Screenshot from 2022-04-05 21-10-06](https://user-images.githubusercontent.com/80127136/162087264-5b271589-b7ed-41c6-ba39-0027cff30f85.png)
![Screenshot from 2022-04-05 21-25-15](https://user-images.githubusercontent.com/80127136/162087291-875d410f-272b-40d1-8cb1-f6204c673aee.png)

- After building the image I moved to my aws console so that I will check if it's working as expected.

- Then I made some changes in the AMI ID of the each launch template and moved things around.

- Then I run Terraform plan and Terraform apply form the web console.

![Screenshot from 2022-04-05 23-09-01](https://user-images.githubusercontent.com/80127136/162087446-752128de-9259-406f-86f0-b925c1ef8bce.png)
![Screenshot from 2022-04-05 23-26-34](https://user-images.githubusercontent.com/80127136/162087566-2a3cc563-59fc-45e3-879d-c00d110faf71.png)

- The health check for my wordpress and tooling website failed because their success code is 302 which I solved by adding health_check matcher of "200-303". This is because the nat gateway is in the private subnet which I later changed to the public subnet.

![Screenshot from 2022-04-05 23-29-52](https://user-images.githubusercontent.com/80127136/162087817-cdf8e7c0-f076-4925-89f2-df6872b6eb5b.png)
![Screenshot from 2022-04-06 00-03-40](https://user-images.githubusercontent.com/80127136/162089406-290d3d75-61f5-4be7-b977-7bcc19b3739a.png)

- Then I tried to change something in any of the *.tf files and look at "Runs" tab which plan automatically.

![Screenshot from 2022-04-05 23-09-15](https://user-images.githubusercontent.com/80127136/162087511-1dbe8ba0-5fd4-4c87-bec8-7354ebdb8bd9.png)
![Screenshot from 2022-04-06 01-09-43](https://user-images.githubusercontent.com/80127136/162089783-d5756a88-4353-4f8c-b02c-631d6d661fa2.png)

- Then I SSH into my nginx server to do the reverse proxy configuration.

![Screenshot from 2022-04-06 01-00-28](https://user-images.githubusercontent.com/80127136/162089700-596c7b7d-f247-4a51-ab53-9b3d5377f3e1.png)
![Screenshot from 2022-04-06 01-39-48](https://user-images.githubusercontent.com/80127136/162089842-5f7868da-3d24-442c-8e24-d0708af15457.png)

### Practice Task 1 Working with Private repository

- I created 3 branches in my "terraform-cloud" repository for dev, test, prod environments and set dev as the default branch. Make necessary configuration to trigger runs automatically only for dev environment.

![Screenshot from 2022-04-06 02-11-22](https://user-images.githubusercontent.com/80127136/162089906-b929a0b8-d0e3-4d2f-a39a-b810371d6734.png)
![Screenshot from 2022-04-06 02-15-29](https://user-images.githubusercontent.com/80127136/162089937-23017ea0-6bac-4240-a0bc-87e1f5c3a8bc.png)

- Create an Email notifications for plan, error,... events and test it. I was unable to create the notification for slack because I will have to wait for slack to verify the workspace that I just created.

![Screenshot from 2022-04-06 15-40-42](https://user-images.githubusercontent.com/80127136/162090445-eb4ed4d5-888f-43ea-97df-9f53d6f21850.png)

![Screenshot from 2022-04-06 02-27-50](https://user-images.githubusercontent.com/80127136/162090167-edebf5a2-7a3a-454b-8fc8-42968d19095d.png)
![Screenshot from 2022-04-06 02-27-55](https://user-images.githubusercontent.com/80127136/162090217-2d13d47b-2f4f-4baa-a5c8-9d2dc177b7e7.png)
![Screenshot from 2022-04-06 03-26-50](https://user-images.githubusercontent.com/80127136/162090329-64e9fc80-839a-4502-95b7-823415d1886a.png)
![Screenshot from 2022-04-06 03-25-39](https://user-images.githubusercontent.com/80127136/162090371-fff633a7-9411-4b7e-bd44-c5c962edb2ce.png)

- I am supposed to apply destroy from the web console but I destroyed the workspace then I had to deleted the resources manually because I didn't backup the state file.

### Practice Task 2 Working with Private repository

- I Created a simple Terraform repository and cloned [S3-WebApp-Module](https://github.com/hashicorp/learn-private-module-aws-s3-webapp). Added tag to the repository.

![Screenshot from 2022-04-06 15-59-41](https://user-images.githubusercontent.com/80127136/162090550-dd6aa08e-9127-41df-beba-2b74ba30dc9c.png)
![Screenshot from 2022-04-06 16-00-20](https://user-images.githubusercontent.com/80127136/162090588-8c914897-334b-4976-8cd2-bf4153fde5f7.png)
![Screenshot from 2022-04-06 16-16-01](https://user-images.githubusercontent.com/80127136/162090630-2c370501-65cb-4252-9d2f-6d8d00710a2d.png)

- Import the module into my private registry.

![Screenshot from 2022-04-06 16-22-10](https://user-images.githubusercontent.com/80127136/162090754-6cfffffe-0bac-423d-82af-b7364d8081b4.png)
![Screenshot from 2022-04-06 16-23-20](https://user-images.githubusercontent.com/80127136/162090787-e61f8a36-66d9-494e-a42c-f5edfd9cf6e7.png)

- Created a configuration that uses the module in another [repository](https://github.com/akingo7/terramain).

![Screenshot from 2022-04-06 17-27-51](https://user-images.githubusercontent.com/80127136/162090921-4717128d-553c-4cb0-bc89-95937e1edc63.png)
![Screenshot from 2022-04-06 17-28-06](https://user-images.githubusercontent.com/80127136/162090994-40cb2160-abb6-4d1a-8f31-0d3af61e3bc1.png)

- Created a workspace for the configuration and deploy the infrastructure.

![Screenshot from 2022-04-06 17-27-22](https://user-images.githubusercontent.com/80127136/162090867-0bab0753-1fae-4aea-b44f-2e949b8f91c9.png)
![Screenshot from 2022-04-06 17-32-05](https://user-images.githubusercontent.com/80127136/162091062-15971660-4aa9-4cb3-8712-bc8385f9e699.png)
![Screenshot from 2022-04-06 17-31-22](https://user-images.githubusercontent.com/80127136/162091012-091d30e9-28c1-482a-a2a7-be9efdfe8e65.png)

- Then I destroyed the infrastructure.

![Screenshot from 2022-04-06 17-33-48](https://user-images.githubusercontent.com/80127136/162091182-3c3e39e4-aa89-4e2a-ad99-dc8c208db6a2.png)

Thank You
