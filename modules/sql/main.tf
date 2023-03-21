resource "google_sql_database_instance" "main" {
  project             = var.host_project_id
  name                = var.sql_config.name
  region              = var.sql_config.region
  database_version    = var.sql_config.database_version
  deletion_protection = var.sql_config.deletion_protection

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = var.sql_settings.tier
    # disk_autoresize       = var.sql_settings.disk_autoresize
    # disk_autoresize_limit = var.sql_settings.disk_autoresize_limit
    disk_size = var.sql_settings.disk_size
    disk_type = var.sql_settings.disk_type
    ip_configuration {
      ipv4_enabled    = var.sql_ip_config.ipv4_enabled
      private_network = var.sql_ip_config.private_network
      require_ssl     = var.sql_ip_config.require_ssl
    }
  }
}

resource "google_sql_user" "users" {

  name     = var.sql_users.name
  password = var.sql_users.password
  # host   = var.users.host
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "database" {
  name     = var.sql_config.db_name
  instance = google_sql_database_instance.main.name
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = var.sql_private_address.name
  purpose       = var.sql_private_address.purpose
  address_type  = var.sql_private_address.address_type
  prefix_length = var.sql_private_address.prefix_length
  network       = var.sql_ip_config.private_network
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = var.sql_ip_config.private_network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}