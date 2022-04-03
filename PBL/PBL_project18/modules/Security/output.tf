output "bastion_security_group_id" {
  value = aws_security_group.bastion_host.id
}

output "external_lb_security_group_id" {
  value = aws_security_group.external_lb.id
}

output "nginx_security_group_id" {
  value = aws_security_group.nginx.id
}

output "database_security_group_id" {
  value = aws_security_group.database.id
}


output "internal_lb_security_group_id" {
  value = aws_security_group.int_lb.id
}


output "webservers_security_group_id" {
  value = aws_security_group.webservers.id
}