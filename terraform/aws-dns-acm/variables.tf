variable "aws_region" { type = string }
variable "aws_profile" { type = string }
variable "aws_domain" { type = string }
variable "wildcard_cert_domain" { type = string }
variable "create_route53_zone" { type = bool }
variable "tags" { type = map(string) }
