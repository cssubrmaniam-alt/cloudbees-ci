output "cluster_name" { value = google_container_cluster.this.name }
output "cluster_location" { value = google_container_cluster.this.location }
output "get_credentials_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.this.name} --region ${google_container_cluster.this.location} --project ${var.project_id}"
}
