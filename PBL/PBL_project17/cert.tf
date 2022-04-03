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