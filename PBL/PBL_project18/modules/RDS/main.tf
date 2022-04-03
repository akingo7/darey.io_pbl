
resource "aws_db_subnet_group" "ACS-rds" {
  name       = "acs-rds"
  subnet_ids = [var.private_subnet3_id, var.private_subnet4_id]

  tags = merge(
    var.tags,
    {
      Name = format("%s-rds", var.name)
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "ACS-rds" {
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  engine                 = var.db_engine
  engine_version         = "5.7"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.ACS-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.database_security_group_id]
  multi_az               = var.multi_az_db
}