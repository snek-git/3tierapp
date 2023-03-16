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
