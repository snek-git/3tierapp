# ------------------------------------------
# TERRAFORM SERVICE ACCOUNT MODULE
# ------------------------------------------

variable "terraform_service_account_project_id" {
  type = string
}
variable "terraform_service_account_id" {
  type = string
}
variable "terraform_service_account_display_name" {
  type = string
}
variable "terraform_service_account_iam_roles" {
  type = list(string)
}

# ------------------------------------------
# FOLDER MODULE
# ------------------------------------------

variable "folder_configuration" {
  description = "Folder configuration"
}

variable "org_domain" {
  description = "Organization ID"
  type        = string
}

# ------------------------------------------
# PROJECTS MODULE
# ------------------------------------------

variable "dynamic_project_config" {
  type = map(object({
    name                = string
    folder_name         = string
    billing_account     = string
    auto_create_network = bool
    services            = list(string)
  }))
}

# ------------------------------------------
# NETWORK MODULE
# ------------------------------------------

variable "host_project_id" {
  description = "The project ID where the network will be created"
  type        = string
}

variable "service_project_ids" {
  description = "The project ID where the service account will be created"
  type        = list(string)
}

variable "network_config" {
  description = "Dynamic network configuration"
  type = object({
    name                    = string
    project_id              = string
    description             = string
    auto_create_subnetworks = bool
    routing_mode            = string
    mtu                     = number
  })
}

variable "dynamic_subnet_config" {
  description = "Dynamic subnet configuration"
  type = map(object({
    project_id    = string
    network       = string
    region        = string
    ip_cidr_range = string
  }))
}

# ------------------------------------------
# SQL MODULE
# ------------------------------------------

variable "sql_config" {
  description = "values for the SQL instance attributes"
  type = object({
    name                = string
    database_version    = string
    region              = string
    deletion_protection = bool    
    db_name               = string
  })
}

variable "sql_settings" {
  description = "values for the SQL instance settings attribute"
  type = object({
    tier                  = string
    disk_autoresize       = bool
    disk_autoresize_limit = number
    disk_size             = number
    disk_type             = string
  })
}

variable "sql_ip_config" {
  type = object({
    ipv4_enabled    = bool
    private_network = string
    require_ssl     = bool
    # allocated_ip_range = string

  })
}

variable "sql_users" {
  type = object({
    name     = string
    password = string
    # host     = string
  })
}

variable "sql_private_address" {
  description = "The private IP address of the SQL instance"
  type = object({
    name          = string
    purpose       = string
    address_type  = string
    prefix_length = number
  })
}
