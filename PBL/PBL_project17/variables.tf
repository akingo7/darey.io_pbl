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

variable "ami" {} #to define

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


#to define
data "aws_availability_zones" "available" {
  state = "available"
}

variable "name" {
  type = string
}