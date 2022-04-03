
resource "aws_subnet" "public" {
  count                   = local.preferred_number_of_public_subnets
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_public_subnets_on_launch
  cidr_block              = cidrsubnet(var.cidr_block, var.subnets_newbit, count.index)
  availability_zone       = random_shuffle.aws_availability_zones.result[count.index]
  tags = merge(
    var.tags,
    {
      Name = format("Public-Subnet-%s", count.index)
    }
  )
}


resource "aws_subnet" "private" {
  count                   = local.preferred_number_of_private_subnets
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_private_subnets_on_launch
  cidr_block              = cidrsubnet(var.cidr_block, var.subnets_newbit, count.index + local.preferred_number_of_public_subnets)
  availability_zone       = random_shuffle.aws_availability_zones.result[count.index]
  tags = merge(
    var.tags,
    {
      Name = format("Private-Subnet-%s", count.index)
    }
  )
}


