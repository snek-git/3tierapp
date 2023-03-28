variable "vm_config" {
  description = "values for the VM instance attributes"
  type = object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)

    service_account = object({
      scopes = list(string)
    })

    boot_disk = object({
      initialize_params = object({
        image = string
        size  = number
      })
    })

    network_interface = object({
      network    = string
      subnetwork = string

      access_config = object({
        nat_ip       = string
        network_tier = string
      })
    })

    startup_script = string
  })
}

variable "service_project_id" {
  description = "The project ID where the VM will be created"
  type        = string
}

variable "host_project_id" {
  description = "The project ID where the network is located"
  type        = string
}