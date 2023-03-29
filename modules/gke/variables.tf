variable "node_pool_attributes" {
  type = object({
    name       = string
    location   = string
    node_count = number

    node_config = object({
      machine_type = string
      preemptible  = bool
      oauth_scopes = list(string)
    })

    ip_allocation_policy = object({
      cluster_secondary_range_name  = string
      services_secondary_range_name = string
      network                       = string
      subnetwork                    = string
      cluster_ipv4_cidr_block       = string
      services_ipv4_cidr_block      = string
    })
  })
}

variable "cluster_config" {
  type = object({
    name                     = string
    location                 = string
    remove_default_node_pool = bool
    initial_node_count       = number
  })
}

variable "gke_service_account" {
  type = object({
    account_id   = string
    display_name = string
  })
}

variable "service_project_id" {
  description = "The project ID where the network will be created"
  type        = string
}
variable "host_project_id" {
  description = "The project ID where the network will be created"
  type        = string
}


variable "vpc_self_link" {
  description = "The self link of the VPC"
  type        = string
}

variable "subnetwork_self_link" {
  description = "The self link of the subnetwork"
  type        = string
}
  