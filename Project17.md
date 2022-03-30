# AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM PART 2


Click ['https://github.com/akingo7/darey.io_pbl/tree/main/PBL'](PBL) to view the files



- Most of the codes in this project are hard coded with I will work on when I get to project 18.


### Networking

- I recreated VPC form project one and the public subnet

```
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
```

- Then I introduced random_shuffle resource to the code and pass in the availability zone data source so that I will have enough AZ to work with when the number of subnets increase.

```
resource "random_shuffle" "aws_availability_zones" {
  input        = [data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[0]]
  result_count = var.max_number_of_az
}
```

- Then I added the code to create four private subnet.

```

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
```

- Create an Internet Gateway in a file `internet_gateway.tf`

```
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-%s", aws_vpc.vpc.id, "IG")
    }

  )
}
```

- Create one NAT Gateway and one Elastic IP address

```
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.ig,
  ]

  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP", var.name)
    }
  )
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.private.*.id, 0)
  depends_on = [
    aws_internet_gateway.ig
  ]

  tags = merge(
    var.tags,
    {
      Name = format("%s-NAT", var.name)
    }
  )
}
```

### AWS Routes

- Create route table with  aws_route_table resource and route association for the private subnets

```

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
  count          = local.preferred_number_of_private_subnets
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
```

- Create route table, route and route table assosiation for public subnet.

```

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = format("%s-public-route-table", var.name)
    }
  )

}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rta" {
  count          = local.preferred_number_of_public_subnets
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}
```

- Then I run `teraform graph | dot Tsvg > <filename>`.
![Screenshot from 2022-03-29 05-23-45](https://user-images.githubusercontent.com/80127136/160905558-678939e2-5acf-4d54-b7cd-96a2357245cf.png)


- Run `terraform plan` and `terraform apply`

- Create an assume role and IAM policy.

```
resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume role"
    }
  )
}

resource "aws_iam_policy" "policy" {
  name        = "ec2_instance_policy"
  description = "A test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]

  })

  tags = merge(
    var.tags,
    {
      Name = "aws assume policy"
    },
  )

}
```

- Then attach the policy to the assume role with.

```

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.policy.arn
}

```

- Create an instance profile .

```

resource "aws_iam_instance_profile" "ip" {
  name = "aws_instance_profile_test"
  role = aws_iam_role.ec2_instance_role.name
}
```



- Create security group in the file `security.tf`.

```
# --- External Load Balancer ---
resource "aws_security_group" "external_lb" {
  name        = "external_lb"
  description = "Allow http and https to external_lb"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "From all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "From all"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
      Name = "%s-Ext-LB"
    }
  )
}

# --- Bastion Host ---
resource "aws_security_group" "bastion_host" {
  name        = "bastion_host"
  description = "Allow ssh to bastion host"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "From all"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
      Name = "%s-Bastion-Host"
    }
  )
}

# --- Nginx Reverse Proxy  ---
resource "aws_security_group" "nginx" {
  name        = "nginx"
  description = "Allow outbound connection"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "%s-nginx"
    }
  )
}

resource "aws_security_group_rule" "exlb_nginx" {
  type                     = "ingress"
  to_port                  = 443
  from_port                = 443
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
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "%s-Internal-Loadbalancer"
    }
  )
}

resource "aws_security_group_rule" "nginx_int_lb" {
  type                     = "ingress"
  to_port                  = 443
  from_port                = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nginx.id
  security_group_id        = aws_security_group.int_lb.id
}



# --- Webservers ---
resource "aws_security_group" "webservers" {
  name        = "webservers"
  description = "Allow outbound connection"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "%s-webservers"
    }
  )
}

resource "aws_security_group_rule" "int_lb_webserver" {
  type                     = "ingress"
  to_port                  = 443
  from_port                = 443
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
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "%s-database"
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


```

- Create TLS Certificate from ACM, after running `terraform apply` for this step I realized that I have to manually create the hosted zone on route53 for the certificate to easily be approved.

```
resource "aws_acm_certificate" "gabrieldevops" {
  domain_name       = "*.gabrieldevops.ml"
  validation_method = "DNS"
}


resource "aws_route53_zone" "gabrieldevops" {
  name = "gabrieldevops.ml"
}

data "aws_route53_zone" "gabrieldevops" {
  name         = "gabrieldevops.ml"
  private_zone = false
}

resource "aws_route53_record" "gabrieldevops" {
  for_each = {
    for dvo in aws_acm_certificate.gabrieldevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 30
  type            = each.value.type
  zone_id         = data.aws_route53_zone.gabrieldevops.zone_id
}

resource "aws_acm_certificate_validation" "gabrieldevops" {
  certificate_arn         = aws_acm_certificate.gabrieldevops.arn
  validation_record_fqdns = [for record in aws_route53_record.gabrieldevops : record.fqdn]
}

resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.gabrieldevops.zone_id
  name    = "tooling.gabrieldeveps"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.gabrieldevops.zone_id
  name    = "wordpress.gabrieldevops.ml"
  type    = "A"
  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}
```


- Create an external (Internet facing) Application Load Balancer, target group and listener in the file alb.tf.

```
resource "aws_lb" "lb" {
  name     = "ext-alb"
  internal = false
  security_groups = [
    aws_security_group.external_lb.id
  ]

  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  tags = merge(
    var.tags,
    {
      Name = "ACS-ext-alb"
    },
  )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "nginx-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}


resource "aws_lb_listener" "nginx-listner" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.gabrieldevops.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }

}
```

- Create an Internal Application load balancer, target group for the tooling and wordpress each and listener rule.

```
resource "aws_lb" "ialb" {
  name     = "ialb"
  internal = true
  security_groups = [
    aws_security_group.int_lb.id
  ]

  subnets = [
    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  tags = merge(
    var.tags,
    {
      Name = "ACS-int-alb"
    },
  )

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

# --- target group  for wordpress -------

resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "wordpress-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}

# --- target group for tooling -------

resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTPS"
    timeout             = 3
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "tooling-tgt"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id
}

# --- listener rule for tooling target ---

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.gabrieldevops.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}

# listener rule for tooling target

resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.gabrieldevops.ml"]
    }
  }
}
```

- Create Autoscaling Group and Launch template for Bastion and nginx in the file bastion-nginx.tf.

```
resource "aws_key_pair" "keypair" {
  key_name = "mykey"
  public_key = file("./devops.pub")
}


# --- Launch Template For Bastion Host ---
resource "aws_launch_template" "bastion-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bastion_host.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

   key_name = local.keypair

  placement {
    availability_zone = "random_shuffle.aws_availability_zones.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "bastion-launch-template"
      },
    )
  }

  user_data = filebase64("${path.module}/bastion.sh")
}

# --- Autoscaling for bastion  hosts ---

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 150
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  launch_template {
    id      = aws_launch_template.bastion-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "bastion-launch-template"
    propagate_at_launch = true
  }

}


# launch template for nginx

resource "aws_launch_template" "nginx-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = local.keypair

  placement {
    availability_zone = "random_shuffle.aws_availability_zones.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "nginx-launch-template"
      },
    )
  }

  user_data = filebase64("${path.module}/nginx.sh")
}

# ------ Autoscslaling group for reverse proxy nginx ---------

resource "aws_autoscaling_group" "nginx-asg" {
  name                      = "nginx-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 150
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id
  ]

  launch_template {
    id      = aws_launch_template.nginx-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "nginx-launch-template"
    propagate_at_launch = true
  }

}

# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.id
  lb_target_group_arn    = aws_lb_target_group.nginx-tgt.arn
}
```


- Create Autoscaling group and Launch template for wordpress and tooling in the file tooling-wordpress.tf.

```
# launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webservers.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = local.keypair

  placement {
    availability_zone = "random_shuffle.aws_availability_zones.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "wordpress-launch-template"
      },
    )

  }

  user_data = filebase64("${path.module}/wordpress.sh")
}

# ---- Autoscaling for wordpress application

resource "aws_autoscaling_group" "wordpress-asg" {
  name                      = "wordpress-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 150
  health_check_type         = "ELB"
  desired_capacity          = 1
  vpc_zone_identifier = [

    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }
}

# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  lb_target_group_arn    = aws_lb_target_group.wordpress-tgt.arn
}

# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webservers.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ip.id
  }

  key_name = local.keypair

  placement {
    availability_zone = "random_shuffle.aws_availability_zones.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "tooling-launch-template"
      },
    )

  }

  user_data = filebase64("${path.module}/tooling.sh")
}

# ---- Autoscaling for tooling -----

resource "aws_autoscaling_group" "tooling-asg" {
  name                      = "tooling-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [

    aws_subnet.private[0].id,
    aws_subnet.private[1].id
  ]

  launch_template {
    id      = aws_launch_template.tooling-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tooling-launch-template"
    propagate_at_launch = true
  }
}
# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  lb_target_group_arn    = aws_lb_target_group.tooling-tgt.arn
}

```

- Create notification for all the auto scaling group.

```

resource "aws_sns_topic" "sns" {
  name = "user-updates-topic"
}

resource "aws_autoscaling_notification" "autoscaling_notifications" {
  group_names = [

    aws_autoscaling_group.bastion-asg.name,
    aws_autoscaling_group.nginx-asg.name,
    aws_autoscaling_group.wordpress-asg.name,
    aws_autoscaling_group.tooling-asg.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.sns.arn
}


```

- Create KMS key.

```
resource "aws_kms_key" "ACS-kms" {
  description = "KMS key "
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_no}:user/terraform" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.ACS-kms.key_id
}

resource "aws_efs_file_system" "ACS-efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.ACS-kms.arn

  tags = merge(
    var.tags,
    {
      Name = "ACS-efs"
    },
  )
}
```

- Create EFS and it's mount targets.

```

# set first mount target for the EFS 
resource "aws_efs_mount_target" "subnet-1" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[2].id
  security_groups = [aws_security_group.database.id]
}

# set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.ACS-efs.id
  subnet_id       = aws_subnet.private[3].id
  security_groups = [aws_security_group.database.id]
}

# create access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.ACS-efs.id

  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {
    path = "/wordpress"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }

}

# create access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.ACS-efs.id
  posix_user {
    gid = 0
    uid = 0
  }

  root_directory {

    path = "/tooling"

    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }

  }
}

```


- Create MySQL Relational Database Service.

```

resource "aws_db_subnet_group" "ACS-rds" {
  name       = "acs-rds"
  subnet_ids = [aws_subnet.private[2].id, aws_subnet.private[3].id]

  tags = merge(
    var.tags,
    {
      Name = "ACS-rds"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "ACS-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "gabrieldb"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.ACS-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database.id]
  multi_az               = "true"
}
```

![Screenshot from 2022-03-29 05-18-50](https://user-images.githubusercontent.com/80127136/160904694-0d945dc2-8aa0-4a63-8a09-6985f7233036.png)

![Screenshot from 2022-03-29 05-14-32](https://user-images.githubusercontent.com/80127136/160904514-6da1244d-80d7-4433-a494-22517ff3975d.png)
![Screenshot from 2022-03-29 05-15-07](https://user-images.githubusercontent.com/80127136/160904572-d3103923-d89a-4112-af77-b167d4c1d8ae.png)
![Screenshot from 2022-03-29 05-16-03](https://user-images.githubusercontent.com/80127136/160904617-0ac66795-c944-4472-8b69-0fd819de2677.png)
![Screenshot from 2022-03-29 05-17-00](https://user-images.githubusercontent.com/80127136/160904644-1ff77849-e0aa-4d51-942d-4f548b237dc1.png)
![Screenshot from 2022-03-30 00-19-19](https://user-images.githubusercontent.com/80127136/160904883-c4eb5465-2a90-4cd0-9b33-da41c30066ee.png)
![Screenshot from 2022-03-30 00-20-32](https://user-images.githubusercontent.com/80127136/160904917-0711480d-bacd-4295-8f52-e54a8a912262.png)
![Screenshot from 2022-03-30 00-22-58](https://user-images.githubusercontent.com/80127136/160904969-a4556542-6a23-42c7-97b2-a270523380e7.png)
![Screenshot from 2022-03-30 00-23-57](https://user-images.githubusercontent.com/80127136/160905023-44b57c34-6bc9-499e-8c81-0c6d3daeb185.png)
![Screenshot from 2022-03-30 00-24-55](https://user-images.githubusercontent.com/80127136/160905068-6ca76227-cbe6-47ad-b344-0ced594d1da4.png)
![Screenshot from 2022-03-30 00-27-11](https://user-images.githubusercontent.com/80127136/160905100-1aee599a-a8d7-43b7-ab0f-b245b73b08ba.png)


