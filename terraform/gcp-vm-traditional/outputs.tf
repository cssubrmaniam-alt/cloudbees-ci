output "traditional_vm_public_ip" {
  value = google_compute_instance.traditional.network_interface[0].access_config[0].nat_ip
}
