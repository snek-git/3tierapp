# resource "google_service_account" "default" {
#   account_id   = var.gke_service_account.account_id
#   display_name = var.service_account.display_name
# }

resource "google_container_node_pool" "main_nodes" {
  project = var.service_project_id

  name       = var.node_pool_attributes.name
  location   = var.node_pool_attributes.location
  cluster    = google_container_cluster.main.name
  node_count = var.node_pool_attributes.node_count


  node_config {
    disk_size_gb = 10
    preemptible  = var.node_pool_attributes.node_config.preemptible
    machine_type = var.node_pool_attributes.node_config.machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.default.email
    oauth_scopes = var.node_pool_attributes.node_config.oauth_scopes
  }
}

resource "google_container_cluster" "main" {
  name       = var.cluster_config.name
  location   = var.cluster_config.location
  project    = var.service_project_id
  network    = var.vpc_self_link
  subnetwork = var.subnetwork_self_link

  node_config {
    disk_size_gb = 20
  }

  ip_allocation_policy {
    # cluster_ipv4_cidr_block = var.node_pool_attributes.ip_allocation_policy.cluster_ipv4_cidr_block
    cluster_secondary_range_name = var.node_pool_attributes.ip_allocation_policy.cluster_secondary_range_name
    # services_ipv4_cidr_block = var.node_pool_attributes.ip_allocation_policy.services_ipv4_cidr_block
    services_secondary_range_name = var.node_pool_attributes.ip_allocation_policy.services_secondary_range_name
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # service_account             = google_service_account.default.email
  remove_default_node_pool = var.cluster_config.remove_default_node_pool
  initial_node_count       = var.cluster_config.initial_node_count
}
