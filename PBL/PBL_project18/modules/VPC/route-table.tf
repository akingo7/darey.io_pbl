
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = format("%s-private-route-table", var.name)
    }
  )

}

resource "aws_route_table_association" "private_rta" {
  count          = var.preferred_number_of_private_subnets
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = format("%s-public-route-table", var.name)
    }
  )

}


resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.public_route_table.id
  nat_gateway_id      = aws_nat_gateway.nat_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.private_route_table.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rta" {
  count          = var.preferred_number_of_public_subnets
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

