locals {
  preferred_number_of_public_subnets  = var.public_subnets_no == null ? length(data.aws_availability_zones.available) : var.public_subnets_no
  preferred_number_of_private_subnets = var.private_subnets_no == null ? length(data.aws_availability_zones.available) : var.private_subnets_no
  keypair = aws_key_pair.keypair.key_name
}
