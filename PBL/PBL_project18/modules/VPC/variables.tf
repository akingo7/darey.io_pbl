variable "cidr_block" {
  type    = string
  default = "10.80.0.0/16"
}
variable "enable_dns_support" {
  default = true
}
variable "enable_dns_hostnames" {
  default = true
}
variable "enable_classiclink" {
  default = false
}
variable "enable_classiclink_dns_support" {
  default = false
}
variable "tags" {}
variable "preferred_number_of_private_subnets" {}
variable "preferred_number_of_public_subnets" {}
variable "map_public_ip_on_private_subnets_on_launch" {
  default = false
}
variable "map_public_ip_on_public_subnets_on_launch" {
  default = true
}
variable "subnets_newbit" {

}
variable "availability_zone" {

}
variable "name" {

}