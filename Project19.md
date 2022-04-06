# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 4

## Create a Terraform Cloud Account

- I signed up for Terraform cloud account then verify my mail.

- Created an organization named "gabrieldevops".

- Created a github repository then push my terraform codes to the [repository](https://github.com/akingo7/terraform-cloud).

- Configure a workspace with version control workflow then create Terraform Organization Authorization with my github account.

- Added AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY Environment variable then mark both of them as sensitive.

- I then used packer to build Ubuntu 20.04 image for nginx, bastion, tooling and wordpress with provisional to run shell script. When I tried to build the image I got an error which is because I used the same source to build 4 images which doesn't work like that. Then I checked "hashicorp" learning site to learn how it works.

- After building the image I moved to my aws console so that I will check if it's working as expected.

- Then I made some changes in the AMI ID of the each launch template and moved things around.

- Then I run Terraform plan and Terraform apply form the web console.

- Then I tried to change something in any of the *.tf files and look at "Runs" tab which plan automatically.

### Practice Task 1 Working with Private repository

- I created 3 branches in my "terraform-cloud" repository for dev, test, prod environments and set dev as the default branch. Make necessary configuration to trigger runs automatically only for dev environment.

- Create an Email notifications for plan, error,... events and test it.

- I am supposed to apply destroy from the web console but I destroyed the workspace then I had to deleted the resources manually because I didn't backup the state file.

### Practice Task 2 Working with Private repository

- I Created a simple Terraform repository and cloned [S3-WebApp-Module](https://github.com/hashicorp/learn-private-module-aws-s3-webapp).

- Import the module into my private registry.

- Create a configuration that uses the module in another repository.

- Create a workspace for the configuration and deploy the infrastructure.