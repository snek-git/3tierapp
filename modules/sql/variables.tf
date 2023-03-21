variable "host_project_id" {
  description = "The project ID where the network will be created"
  type        = string
}

variable "service_project_ids" {
  description = "The project ID where the service account will be created"
  type        = list(string)
}

variable "sql_config" {
  description = "values for the SQL instance attributes"
  type = object({
    name                = string
    database_version    = string
    region              = string
    deletion_protection = bool

  })
}

variable "settings" {
  description = "values for the SQL instance settings attribute"
  type = object({
    tier = string

  })
}

variable "ip_config" {
  type = object({
    ipv4_enabled       = bool
    private_network    = string
    require_ssl        = bool
    allocated_ip_range = string

  })
}

variable "users" {
  type = list(object({
    name     = string
    password = string
    host     = string
  }))
}