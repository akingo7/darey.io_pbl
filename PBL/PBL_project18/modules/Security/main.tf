# --- External Load Balancer ---
resource "aws_security_group" "external_lb" {
  name        = "external_lb"
  description = "Allow http and https to external_lb"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.external_lb_port
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-Ext-LB", var.name)
    }
  )
}

# --- Bastion Host ---
resource "aws_security_group" "bastion_host" {
  name        = "bastion_host"
  description = "Allow ssh to bastion host"
  vpc_id      = var.vpc_id


  dynamic "ingress" {
    for_each = var.bastion_port
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_block
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-Bastion-Host", var.name)
    }
  )
}

# --- Nginx Reverse Proxy  ---
resource "aws_security_group" "nginx" {
  name        = "nginx"
  description = "Allow outbound connection"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-nginx", var.name)
    }
  )
}

resource "aws_security_group_rule" "exlb_nginx" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.external_lb.id
  security_group_id        = aws_security_group.nginx.id
}

resource "aws_security_group_rule" "b_nginx" {
  type                     = "ingress"
  to_port                  = 22
  from_port                = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_host.id
  security_group_id        = aws_security_group.nginx.id
}





# --- Internal LB ---
resource "aws_security_group" "int_lb" {
  name        = "int_lb"
  description = "Allow outbound connection"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-Internal-Loadbalancer", var.name)
    }
  )
}

resource "aws_security_group_rule" "nginx_int_lb" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx.id
  security_group_id        = aws_security_group.int_lb.id
}



# --- Webservers ---
resource "aws_security_group" "webservers" {
  name        = "webservers"
  description = "Allow outbound connection"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-webservers", var.name)
    }
  )
}

resource "aws_security_group_rule" "int_lb_webserver" {
  type                     = "ingress"
  to_port                  = 80
  from_port                = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.int_lb.id
  security_group_id        = aws_security_group.webservers.id
}

resource "aws_security_group_rule" "ba_webserver" {
  type                     = "ingress"
  to_port                  = 22
  from_port                = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_host.id
  security_group_id        = aws_security_group.webservers.id
}



# --- Database Layer ---
resource "aws_security_group" "database" {
  name        = "database"
  description = "Allow outbound connection"
  vpc_id      = var.vpc_id
  depends_on = [
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = format("%s-Database", var.name)
    }
  )
}

resource "aws_security_group_rule" "webserver_mysql" {
  type                     = "ingress"
  to_port                  = 3306
  from_port                = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webservers.id
  security_group_id        = aws_security_group.database.id
}


resource "aws_security_group_rule" "webserver_efs" {
  type                     = "ingress"
  to_port                  = 2049
  from_port                = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webservers.id
  security_group_id        = aws_security_group.database.id
}


resource "aws_security_group_rule" "bastion_efs" {
  type                     = "ingress"
  to_port                  = 2049
  from_port                = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_host.id
  security_group_id        = aws_security_group.database.id
}

