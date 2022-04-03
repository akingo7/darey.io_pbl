output "nginx_target_group" {
  value = aws_lb_target_group.nginx-tgt.arn
}

output "wordpress_target_group" {
  value = aws_lb_target_group.wordpress-tgt.arn
}

output "tooling_target_group" {
  value = aws_lb_target_group.tooling-tgt.arn
}
output "external_lb_dns_name" {
  value = aws_lb.lb.dns_name
}


output "internal_lb_dns_name" {
  value = aws_lb.ialb.dns_name
}