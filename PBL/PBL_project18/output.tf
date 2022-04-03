
output "alb_dns_name" {
  value = module.alb.external_lb_dns_name
}

output "alb_target_group_arn" {
  value = module.alb.nginx_target_group
}