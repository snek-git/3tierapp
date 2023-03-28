resource "google_compute_instance" "default" {

  project      = var.service_project_id
  name         = var.vm_config.name
  machine_type = var.vm_config.machine_type
  #   zone         = var.vm_config.zone
  # tags = var.vm_config.tags

  #   service_account {
  #     email  = google_service_account.default.email
  #     scopes = var.vm_config.service_account.scopes
  #   }

  boot_disk {
    initialize_params {
      image = var.vm_config.boot_disk.initialize_params.image
      size  = var.vm_config.boot_disk.initialize_params.size
    }
  }

  network_interface {
    subnetwork         = var.vm_config.network_interface.subnetwork
    subnetwork_project = var.host_project_id
    access_config {
      #   nat_ip       = var.vm_config.network_interface.access_config.nat_ip
      #   network_tier = var.vm_config.network_interface.access_config.network_tier
    }
  }

  metadata_startup_script = var.vm_config.startup_script
}

# resource "google_service_account" "default" {
#   account_id   = "service_account_id"
#   display_name = "Service Account"
# }