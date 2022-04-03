variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cidr_block" {}
variable "enable_dns_support" {}
variable "enable_dns_hostnames" {}
variable "enable_classiclink" {}
variable "enable_classiclink_dns_support" {}
variable "subnets_newbit" {
  type = number
}
variable "public_subnets_no" {
  type = number
}

variable "private_subnets_no" {
  type = number
}
variable "map_public_ip_on_public_subnets_on_launch" {

}
variable "map_public_ip_on_private_subnets_on_launch" {

}

variable "max_number_of_az" {

}

variable "tags" {
  description = "Variable to map default tags to each resource"
  type        = map(string)
}

variable "ami" {
  type = map(any)
  default = {
    us-east-1    = "ami-04505e74c0741db8d"
    eu-central-1 = "ami-0d527b8c289b4af7f"
  }
}

variable "master-username" {
  type        = string
  description = "RDS username"
}
variable "master-password" {
  type        = string
  description = "RDS password"
}
variable "account_no" {
  type        = string
  description = "My account number"
}

variable "name" {
  type = string
}

variable "instance_type" {
  type = string
}


variable "external_lb_port" {
  default = {
    http = {
      port        = 80
      description = "From All"
    }

    https = {
      port        = 443
      description = "From All"
    }
  }
}

variable "bastion_port" {
  default = {
    ssh = {
      port        = 22
      description = "ssh from all"
      cidr_block  = ["0.0.0.0/0"]
    }
  }
}

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "db_name" {
  type    = string
  default = "gabrieldb"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_storage_type" {
  type    = string
  default = "gp2"
}

variable "multi_az_db" {
  type    = string
  default = "true"
}
