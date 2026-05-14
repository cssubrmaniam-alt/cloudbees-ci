resource "google_project_service" "services" {
  for_each = toset(["container.googleapis.com","compute.googleapis.com","iam.googleapis.com"])
  project = var.project_id
  service = each.key
  disable_on_destroy = false
}

resource "google_container_cluster" "this" {
  name = var.gke_cluster_name
  location = var.region
  remove_default_node_pool = true
  initial_node_count = 1
  deletion_protection = false
  resource_labels = var.labels
  depends_on = [google_project_service.services]
}

resource "google_container_node_pool" "primary" {
  name = "${var.gke_cluster_name}-pool"
  location = var.region
  cluster = google_container_cluster.this.name
  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    labels = var.labels
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
