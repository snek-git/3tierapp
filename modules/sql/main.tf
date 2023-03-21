resource "google_sql_database_instance" "main" {
  project             = var.host_project_id
  name                = var.sql_config.name
  region              = var.sql_config.region
  database_version    = var.sql_config.database_version
  deletion_protection = var.sql_config.deletion_protection
  settings {
    tier                  = var.sql_settings.tier
    disk_autoresize       = var.sql_settings.disk_autoresize
    disk_autoresize_limit = var.sql_settings.disk_autoresize_limit
    disk_size             = var.sql_settings.disk_size
    disk_type             = var.sql_settings.disk_type
    ip_configuration {
      ipv4_enabled    = var.sql_ip_config.ipv4_enabled
      private_network = var.sql_ip_config.private_network
      require_ssl     = var.sql_ip_config.require_ssl
    }
  }
}

resource "google_sql_user" "users" {
  for_each = var.sql_users
  name     = each.var.sql_users.name
  password = each.var.sql_users.password
  # host   = var.users.host
  instance = google_sql_database_instance.main.name
}

resource "google_sql_database" "database_deletion_policy" {
  name     = "demo-db"
  instance = google_sql_database_instance.main.name
  deletion_policy = "ABANDON"
}