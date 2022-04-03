resource "aws_vpc" "vpc" {
  cidr_block                     = var.cidr_block
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  tags = merge(
    var.tags,
    {
      Name = "VPC"
    }
  )
}