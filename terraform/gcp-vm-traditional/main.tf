resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_subnetwork" "traditional" {
  name          = "${var.vm_name}-subnet"
  ip_cidr_range = "10.20.0.0/24"
  region        = var.region
  network       = "default"

  depends_on = [google_project_service.compute]
}

resource "google_compute_firewall" "allow_jenkins_lab" {
  name    = "${var.vm_name}-allow-jenkins"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "8443", "50000"]
  }

  source_ranges = var.allowed_source_ranges
  target_tags   = [var.vm_name]

  depends_on = [google_project_service.compute]
}

resource "google_compute_instance" "traditional" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  labels       = var.labels
  tags         = [var.vm_name]

  boot_disk {
    initialize_params {
      image  = "debian-cloud/debian-12"
      size   = var.disk_gb
      type   = "pd-balanced"
      labels = var.labels
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.traditional.self_link

    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  depends_on = [
    google_project_service.compute,
    google_compute_subnetwork.traditional
  ]
}
