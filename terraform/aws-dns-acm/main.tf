resource "aws_route53_zone" "this" {
  count = var.create_route53_zone ? 1 : 0
  name  = var.aws_domain
  tags  = var.tags
}

resource "aws_acm_certificate" "wildcard" {
  domain_name       = var.wildcard_cert_domain
  validation_method = "DNS"
  tags              = var.tags
  lifecycle { create_before_destroy = true }
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.create_route53_zone ? {
    for dvo in aws_acm_certificate.wildcard.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      type = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}
  allow_overwrite = true
  zone_id = aws_route53_zone.this[0].zone_id
  name = each.value.name
  type = each.value.type
  ttl = 300
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "wildcard" {
  count = var.create_route53_zone ? 1 : 0
  certificate_arn = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
