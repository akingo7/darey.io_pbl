# AUTOMATE INFRASTRUCTURE AS CODE USING IAC TERRAFORM PART 1

- Before starting this project I installed boto3 on my local machine then I created a user named "terraform" with only programatic access only and grant the user with **AdministratorAccess**.
![Screenshot from 2022-03-25 01-16-14](https://user-images.githubusercontent.com/80127136/160159430-5eec618d-b79a-41af-8ba0-81b7e9bd3234.png)
![Screenshot from 2022-03-25 01-16-58](https://user-images.githubusercontent.com/80127136/160159449-71837d50-aef5-4600-a65a-74c017d9d2ea.png)

- Then I connected to AWS using the access key and the secret key which I copied after creating the user.
![Screenshot from 2022-03-25 01-50-42](https://user-images.githubusercontent.com/80127136/160159676-ff9fbcd8-79e2-4a5f-90dd-555465cdfe1c.png)

- Then I created S3 bucket with versioning enabled which I will be storing my terraform state file. I then run `aws s3 ls` to see my machine is configured well.
![Screenshot from 2022-03-25 01-47-51](https://user-images.githubusercontent.com/80127136/160159589-c7ce8dd2-c436-4643-b30b-c379ea4f30d5.png)
![Screenshot from 2022-03-25 01-48-33](https://user-images.githubusercontent.com/80127136/160159628-c7e31311-ae0b-470e-9388-352fbdfb4cf5.png)
![Screenshot from 2022-03-25 01-52-10](https://user-images.githubusercontent.com/80127136/160159734-a30c2296-1a1f-4ace-a502-2abe389f96aa.png)

- I then created a directory "PBL" on my local machine and created a file which I used to create s3 backend to store terraform state file.
![Screenshot from 2022-03-25 02-00-20](https://user-images.githubusercontent.com/80127136/160159808-8f818e48-9f86-4cd8-bd1a-e5871046b020.png)
![Screenshot from 2022-03-25 02-02-07](https://user-images.githubusercontent.com/80127136/160159852-e940d60f-0d9f-4a54-abb1-57da2dad4bb8.png)

### VPC | SUBNET

- I created another file "main.tf"("min.tf") Then I added the requied provider and provider.
![Screenshot from 2022-03-25 02-14-49](https://user-images.githubusercontent.com/80127136/160159926-16bec781-8f75-4f20-b530-1e0b6775b2db.png)
![Screenshot from 2022-03-25 02-18-23](https://user-images.githubusercontent.com/80127136/160160147-957ad5df-4aa0-469b-8c82-caaf6c3d3e4e.png)

- I then run `terraform fmt` to format the file very well and `terraform init` which will download all the required plugins for aws and will make my work more easier because I will be seeing all the argument, resource,... suggestions.

- Then I added vpc resource to my code and run `terraform plan` and `terraform apply` which created VPC when I checked it AWS and created backup file in my s3 bucket.
![Screenshot from 2022-03-25 02-57-05](https://user-images.githubusercontent.com/80127136/160160341-d4b6a60a-0e07-41d7-92ed-145ef3b6ba6a.png)
![Screenshot from 2022-03-25 03-03-14](https://user-images.githubusercontent.com/80127136/160160370-c8ede649-c532-4148-9cad-47ab16ed21b4.png)
![Screenshot from 2022-03-25 03-06-03](https://user-images.githubusercontent.com/80127136/160160408-364996c5-5195-4696-ad23-e85b3d90115f.png)

- Then I added two aws_subnet resource to my code to create two public subnet and I applied the changes.
![Screenshot from 2022-03-25 03-08-30](https://user-images.githubusercontent.com/80127136/160160448-67f1fee8-8061-4033-814d-ee886df31032.png)
![Screenshot from 2022-03-25 03-15-28](https://user-images.githubusercontent.com/80127136/160160518-be90f56c-f25e-49af-b9f2-4d76261b19a3.png)
![Screenshot from 2022-03-25 03-17-02](https://user-images.githubusercontent.com/80127136/160160547-f0a0e31d-e07a-472e-aeb1-4c1784e802eb.png)
![Screenshot from 2022-03-25 03-21-08](https://user-images.githubusercontent.com/80127136/160160636-4893bc5d-5dca-40eb-ba26-4879536077d5.png)
![Screenshot from 2022-03-25 03-24-14](https://user-images.githubusercontent.com/80127136/160160651-2a887a5e-df76-4ff5-9d53-aac7baa2313d.png)
![Screenshot from 2022-03-25 03-25-44](https://user-images.githubusercontent.com/80127136/160160709-73bb3771-2561-438e-96e5-e19f21a548fb.png)

- Then I destroy the infrastructure because it's still under development.
![Screenshot from 2022-03-25 03-28-50](https://user-images.githubusercontent.com/80127136/160160730-255337a0-2707-414f-a128-7ebf012279a5.png)

### Fixing Hard Coded Values

- I created variables declaring the default value of the attributes of the provider, aws_subnet and aws_vpc, then I refer them to their corresponding attributes. Introduced count attribute to the subnet, Introduced `data.aws_availability_zones.available.names` to get the list of all availible availability zones then pass it to the availability zones attribute in the subnet resource. Used cidrsubnet function for the cidr_block attribute in subnet resource.
![Screenshot from 2022-03-25 03-45-08](https://user-images.githubusercontent.com/80127136/160160821-e46a9568-c04f-4517-ab13-a19a492a0179.png)
![Screenshot from 2022-03-25 03-52-00](https://user-images.githubusercontent.com/80127136/160160887-c033b2f8-c9ec-4cc0-96b2-3c958d4ad58a.png)
![Screenshot from 2022-03-25 04-10-11](https://user-images.githubusercontent.com/80127136/160160964-4ecd7fdb-6c0d-4bc2-9090-bcf8cce9da65.png)
![Screenshot from 2022-03-25 04-31-11](https://user-images.githubusercontent.com/80127136/160161068-642d21a4-2936-46b5-8cdf-ee8d40e8ec4a.png)
![Screenshot from 2022-03-25 04-44-12](https://user-images.githubusercontent.com/80127136/160161146-1a96d524-0e54-4d6c-a0eb-e72133a9fdec.png)
![Screenshot from 2022-03-25 04-27-45](https://user-images.githubusercontent.com/80127136/160160997-660e5fef-9239-442d-83e4-5c4cf515817b.png)
![Screenshot from 2022-03-25 04-30-43](https://user-images.githubusercontent.com/80127136/160161011-9bbf23cc-def8-4a6f-bd8e-0485ca1561b9.png)
![Screenshot from 2022-03-25 04-50-35](https://user-images.githubusercontent.com/80127136/160161317-6d8ffc54-9811-4703-83d3-7c6bdc589963.png)

- Then I created two files: "terraform.tfvars" for the values of variable. This file will be ignored by the version control system; "variable.tf" to move the variable declarations from main.tf file.
![Screenshot from 2022-03-25 04-44-27](https://user-images.githubusercontent.com/80127136/160161154-5587031f-d692-4889-901f-ce8a18d56fe8.png)
![Screenshot from 2022-03-25 04-44-38](https://user-images.githubusercontent.com/80127136/160161171-8feb624d-12fb-49f6-a423-a9045fb12a13.png)
![Screenshot from 2022-03-25 04-45-23](https://user-images.githubusercontent.com/80127136/160161206-cf1d306a-a841-4118-9e5f-526267a14806.png)

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

Thank You.
