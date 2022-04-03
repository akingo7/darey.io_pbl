resource "aws_key_pair" "keypair" {
  key_name   = "mykey"
  public_key = file("${path.module}/devops.pub")
}


# --- Launch Template For Bastion Host ---
resource "aws_launch_template" "bastion-launch-template" {
  image_id               = lookup(var.ami, var.region, "ami-0d527b8c289b4af7f")
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.bastion_security_group_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  key_name = aws_key_pair.keypair.key_name

  placement {
    availability_zone = var.availability_zone[0]
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

  user_data = filebase64("${path.module}/../../scripts/bastion.sh")
}

# --- Autoscaling for bastion hosts ---

resource "aws_autoscaling_group" "bastion-asg" {
  name                      = "bastion-asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 150
  health_check_type         = "ELB"
  desired_capacity          = 1

  vpc_zone_identifier = [
    var.public_subnet1_id,
    var.public_subnet2_id
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

  lifecycle {
    create_before_destroy = true
  }

}


# launch template for nginx

resource "aws_launch_template" "nginx-launch-template" {
  image_id               = lookup(var.ami, var.region, "ami-0d527b8c289b4af7f")
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.nginx_security_group_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  key_name = aws_key_pair.keypair.key_name

  placement {
    availability_zone = var.availability_zone[0]
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
# user_data = base64(templatefile("${path.module}/../../scripts/nginx.sh", {internalLB = var.internal_lb_dns_name}))
  user_data = filebase64("${path.module}/../../scripts/nginx.sh")
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
    var.public_subnet1_id,
    var.public_subnet2_id
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

  lifecycle {
    create_before_destroy = true
  }

}

# attaching autoscaling group of nginx to external load balancer
resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
  autoscaling_group_name = aws_autoscaling_group.nginx-asg.id
  lb_target_group_arn    = var.nginx_target_group_arn
}


# launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {
  image_id               = lookup(var.ami, var.region, "ami-0d527b8c289b4af7f")
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.webservers_security_group_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  key_name = aws_key_pair.keypair.key_name

  placement {
    availability_zone = var.availability_zone[0]
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

  user_data = filebase64("${path.module}/../../scripts/wordpress.sh")
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

    var.private_subnet1_id,
    var.private_subnet2_id
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

  lifecycle {
    create_before_destroy = true
  }
}

# attaching autoscaling group of  wordpress application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
  autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
  lb_target_group_arn    = var.wordpress_target_group_arn
}

# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {
  image_id               = lookup(var.ami, var.region, "ami-0d527b8c289b4af7f")
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.webservers_security_group_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  key_name = aws_key_pair.keypair.key_name

  placement {
    availability_zone = var.availability_zone[0]
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

  user_data = filebase64("${path.module}/../../scripts/tooling.sh")
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

    var.private_subnet1_id,
    var.private_subnet2_id
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

  lifecycle {
    create_before_destroy = true
  }
}
# attaching autoscaling group of  tooling application to internal loadbalancer
resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
  autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
  lb_target_group_arn    = var.tooling_target_group_arn
}
