resource "google_sql_database_instance" "main" {
  project               = var.host_project_id
  name                  = var.sql_config.name
  region                = var.sql_config.region
  database_version      = var.sql_config.database_version
  deletion_protection   = var.sql_config.deletion_protection
  disk_autoresize       = each.value.disk_autoresize
  disk_autoresize_limit = each.value.disk_autoresize_limit
  disk_size             = each.value.disk_size
  disk_type             = each.value.disk_type
  settings {
    tier = var.settings.tier
    ip_configuration {
      ipv4_enabled    = var.ip_config.ipv4_enabled
      private_network = var.ip_config.private_network
    # require_ssl     = var.ip_config.require_ssl
    }
  }
}

resource "google_sql_user" "users" {
  for_each = var.users
  name     = each.var.users.name
  password = each.var.users.password
  # host   = var.users.host
  instance = google_sql_database_instance.main.name
}