# AUTOMATE INFRASTRUCTURE USING IAC TERRAFORM

## Introducing Backend and State Locking

- I created a file backend.tf then paste code below to create s3 resource for the backend and dynamodb for the state locking.

```hcl
resource "aws_s3_bucket" "terraform_state" {
  bucket = "gabriel-devops-terraform"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

- After adding the code then I run `terraform apply` to create the resource since terraform want us to create the resource before configuring the backend.

- After the resource is created successfully I added the backend block to configure s3 backed.

```hcl

  backend "s3" {
    bucket = "gabriel-devops-terraform"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt = true

  }

```

- Then I re-initialize terraform.

## Refactoring Project Using Modules

- I then break down the Terraform codes to have all their resources in their respective modules. I will be pasting only the code to the main.tf file in the root module here. Click on [PBL](https://github.com/akingo7/darey.io_pbl/tree/main/PBL/PBL_project18) to visit the files.

```hcl
module "networking" {
  source                              = "./modules/VPC"
  tags                                = var.tags
  preferred_number_of_private_subnets = local.preferred_number_of_private_subnets
  preferred_number_of_public_subnets  = local.preferred_number_of_public_subnets
  subnets_newbit                      = var.subnets_newbit
  availability_zone                   = random_shuffle.aws_availability_zones.result
  name                                = var.name
}

module "security" {
  source           = "./modules/Security"
  vpc_id           = module.networking.vpc_id
  external_lb_port = var.external_lb_port
  bastion_port     = var.bastion_port
  name             = var.name
  tags             = var.tags
}

module "rds" {
  source                     = "./modules/RDS"
  private_subnet3_id         = module.networking.private_subnet3_id
  private_subnet4_id         = module.networking.private_subnet4_id
  name                       = var.name
  tags                       = var.tags
  db_instance_class          = var.db_instance_class
  db_name                    = var.db_name
  master-username            = var.master-username
  master-password            = var.master-password
  database_security_group_id = module.security.database_security_group_id
  db_engine                  = var.db_engine
  db_allocated_storage       = var.db_allocated_storage
  db_storage_type            = var.db_storage_type
  multi_az_db                = var.multi_az_db
}

module "roles" {
  source = "./modules/Compute"
  name   = var.name
  tags   = var.tags
}

module "efs" {
  source                     = "./modules/EFS"
  name                       = var.name
  tags                       = var.tags
  private_subnet3_id         = module.networking.private_subnet3_id
  private_subnet4_id         = module.networking.private_subnet4_id
  database_security_group_id = module.security.database_security_group_id
  account_no                 = var.account_no
}

module "alb" {
  source                        = "./modules/ALB"
  external_lb_security_group_id = module.security.external_lb_security_group_id
  internal_lb_security_group_id = module.security.internal_lb_security_group_id
  public_subnet1_id             = module.networking.public_subnet1_id
  public_subnet2_id             = module.networking.public_subnet2_id
  private_subnet1_id            = module.networking.private_subnet1_id
  private_subnet2_id            = module.networking.private_subnet2_id
  tags                          = var.tags
  name                          = var.name
  vpc_id                        = module.networking.vpc_id

}

module "asg" {
  source                        = "./modules/Autoscaling"
  tooling_target_group_arn      = module.alb.tooling_target_group
  wordpress_target_group_arn    = module.alb.wordpress_target_group
  nginx_target_group_arn        = module.alb.nginx_target_group
  ami                           = var.ami
  region                        = var.region
  instance_type                 = var.instance_type
  external_lb_security_group_id = module.security.external_lb_security_group_id
  internal_lb_security_group_id = module.security.internal_lb_security_group_id
  bastion_security_group_id     = module.security.bastion_security_group_id
  nginx_security_group_id       = module.security.nginx_security_group_id
  webservers_security_group_id  = module.security.webservers_security_group_id
  public_subnet1_id             = module.networking.public_subnet1_id
  public_subnet2_id             = module.networking.public_subnet2_id
  private_subnet1_id            = module.networking.private_subnet1_id
  private_subnet2_id            = module.networking.private_subnet2_id
  tags                          = var.tags
  name                          = var.name
  vpc_id                        = module.networking.vpc_id
  iam_instance_profile          = module.roles.iam_instance_profile
  availability_zone             = random_shuffle.aws_availability_zones.result
  internal_lb_dns_name = module.alb.internal_lb_dns_name

}
```
