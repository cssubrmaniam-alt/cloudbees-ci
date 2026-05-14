variable "project_id" { type = string }
variable "region" { type = string }
variable "gke_cluster_name" { type = string }
variable "node_count" { type = number }
variable "machine_type" { type = string }
variable "labels" { type = map(string) }
