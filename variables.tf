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
