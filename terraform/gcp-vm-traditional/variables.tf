variable "project_id" { type = string }
variable "region" { type = string }
variable "zone" { type = string }
variable "vm_name" { type = string }
variable "machine_type" { type = string }
variable "disk_gb" { type = number }
variable "labels" { type = map(string) }
