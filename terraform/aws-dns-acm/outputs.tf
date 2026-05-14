output "route53_name_servers" {
  value = var.create_route53_zone ? aws_route53_zone.this[0].name_servers : []
}
output "acm_certificate_arn" {
  value = aws_acm_certificate.wildcard.arn
}
