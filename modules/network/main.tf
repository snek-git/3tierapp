resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

# A service project gains access to network resources provided by its
# associated host project.
resource "google_compute_shared_vpc_service_project" "service" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  for_each        = toset(var.service_project_ids)
  service_project = each.key
}

resource "google_compute_network" "dynamic_vpc" {
  name        = var.network_config.name
  project     = var.network_config.project_id
  description = var.network_config.description

  auto_create_subnetworks = var.network_config.auto_create_subnetworks
  mtu                     = var.network_config.mtu
  routing_mode            = var.network_config.routing_mode
}

resource "google_compute_subnetwork" "dynamic_subnetwork" {
  for_each = var.dynamic_subnet_config

  ip_cidr_range = each.value.ip_cidr_range
  name          = each.key
  network       = each.value.network
  region        = each.value.region
  project       = each.value.project_id
}
