data "aws_availability_zones" "available" {
  state = "available"
}

resource "random_shuffle" "aws_availability_zones" {
  input        = [data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[0]]
  result_count = var.max_number_of_az
}

locals {
  preferred_number_of_public_subnets  = var.public_subnets_no == null ? length(data.aws_availability_zones.available) : var.public_subnets_no
  preferred_number_of_private_subnets = var.private_subnets_no == null ? length(data.aws_availability_zones.available) : var.private_subnets_no
}
