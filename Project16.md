# AUTOMATE INFRASTRUCTURE AS CODE USING IAC TERRAFORM PART 1

- Before starting this project I installed boto3 on my local machine then I created a user named "terraform" with only programatic access only and grant the user with **AdministratorAccess**.

- Then I connected to AWS using the access key and the secret key which I copied after creating the user.

- Then I created S3 bucket with versioning enabled which I will be storing my terraform state file. I then run `aws s3 ls` to see my machine is configured well.

- I then created a directory "PBL" on my local machine and created a file which I used to create s3 backend to store terraform state file.

### VPC | SUBNET

- I created another file "main.tf" Then I added the requied provider and provider.

- I then run `terraform fmt` to format the file very well and `terraform init` which will download all the required plugins for aws and will make my work more easier because I will be seeing all the argument, resource,... suggestions.

- Then I added vpc resource to my code and run `terraform plan` and `terraform apply` which created VPC when I checked it AWS and created backup file in my s3 bucket.

- Then I added two aws_subnet resource to my code to create two public subnet and I applied the changes.

- Then I destroy the infrastructure because it's still under development.

### Fixing Hard Coded Values

- I created variables declaring the default value of the attributes of the provider, aws_subnet and aws_vpc, then I refer them to their corresponding attributes. Introduced count attribute to the subnet, Introduced `data.aws_availability_zones.available.names` to get the list of all availible availability zones then pass it to the availability zones attribute in the subnet resource. Used cidrsubnet function for the cidr_block attribute in subnet resource.


- Then I created two files: "terraform.tfvars" for the values of variable. This file will be ignored by the version control system; "variable.tf" to move the variable declarations from main.tf file.

**backend.tf**
```
terraform {
  backend "s3" {
    bucket = "gabriel-dev-terraform-bucket"
    key    = "terraform/backup"
    region = "eu-central-1"
  }
}

```

**main.tf** 
```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block                     = var.cidr_block
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_dns_support             = var.enable_dns_support
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

}

resource "aws_subnet" "public" {
  count                   = local.count_condition
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}



```

**variable.tf**
```
variable "region" {
  default = "eu-central-1"
}
variable "cidr_block" {
  default = "172.0.0.0/16"
}
variable "enable_classiclink" {
  default = false
}
variable "enable_classiclink_dns_support" {
  default = false
}
variable "enable_dns_hostnames" {
  default = true
}
variable "enable_dns_support" {
  default = true
}
variable "map_public_ip_on_launch" {
  default = true
}

variable "preferred_number_of_public_subnets" {
  default = null
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  count_condition = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
}

```

**terraform.tfvars**
```
region                             = "eu-central-1"
cidr_block                         = "172.0.0.0/16"
enable_classiclink                 = false
enable_classiclink_dns_support     = false
enable_dns_hostnames               = true
enable_dns_support                 = true
map_public_ip_on_launch            = true
preferred_number_of_public_subnets = 2

```
