org_domain = "snek.page" # Change to your domain

# ------------------------------------------
# TERRAFORM SERVICE ACCOUNT MODULE
# ------------------------------------------

terraform_service_account_project_id   = "three-tier-app-main-f"     # Change to your project ID
terraform_service_account_id           = "terraform-service-account" # Change to your service account ID
terraform_service_account_display_name = "Terraform Service Account" # Change to your service account display name
terraform_service_account_iam_roles = [
  "roles/resourcemanager.projectCreator",
  "roles/resourcemanager.folderAdmin",
  "roles/resourcemanager.organizationAdmin",
  "roles/billing.user",
  "roles/iam.serviceAccountUser",
  "roles/serviceusage.serviceUsageAdmin",
  "roles/compute.admin",
  "roles/compute.networkAdmin",
  "roles/compute.xpnAdmin",
  "roles/storage.objectAdmin",
  "roles/compute.securityAdmin"
]

# ------------------------------------------
# FOLDER MODULE
# ------------------------------------------

folder_configuration = {
  "3tier" : [] # Change to your folder strcuture
}

# ------------------------------------------
# PROJECTS MODULE
# ------------------------------------------

dynamic_project_config = {

  "felo-task-host-project" = { # Change to your project ID
    name                = "felo-task-host-project",
    folder_name         = "3tier",
    billing_account     = "013BBA-BA592C-7635DE", # Change to your billing account
    auto_create_network = false
    services = [
      "compute.googleapis.com",
      "cloudbilling.googleapis.com",
      "iam.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "iap.googleapis.com",
      "serviceusage.googleapis.com"
    ]
  }

  "felo-task-service-project" = { # Change to your project ID
    name                = "felo-task-service-project",
    folder_name         = "3tier",
    billing_account     = "013BBA-BA592C-7635DE", # Change to your billing account
    auto_create_network = false
    services = [
      "compute.googleapis.com",
      "cloudbilling.googleapis.com",
      "iam.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "iap.googleapis.com",
      "serviceusage.googleapis.com"
    ]
  }

}

# ------------------------------------------
# NETWORK MODULE
# ------------------------------------------

host_project_id     = "felo-task-host-project"      # Change to your project ID
service_project_ids = ["felo-task-service-project"] # Change to your project ID
service_project_id  = "felo-task-service-project"

network_config = {
  name                    = "three-tier-vpc"
  project_id              = "felo-task-host-project" # Change to your project ID
  description             = "Host VPC"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

dynamic_subnet_config = {
  "vmsubnet" = {
    network       = "three-tier-vpc"
    project_id    = "felo-task-host-project" # Change to your project ID
    ip_cidr_range = "10.0.0.96/27"
    region        = "us-east1"
  }
  "k8subnet" = {
    network       = "three-tier-vpc"
    project_id    = "felo-task-host-project" # Change to your project ID
    ip_cidr_range = "10.0.4.0/24"
    region        = "us-east1"
  }

}

# ------------------------------------------
# SQL MODULE
# ------------------------------------------

sql_config = {
  database_version    = "MYSQL_8_0"
  deletion_protection = false
  name                = "threetier-mysql-instance"
  region              = "us-east1"
  db_name             = "demo-db"

}

sql_ip_config = {
  # allocated_ip_range = "value"
  ipv4_enabled    = true
  private_network = "projects/felo-task-host-project/global/networks/three-tier-vpc"
  require_ssl     = false
}

sql_settings = {
  disk_autoresize       = false
  disk_autoresize_limit = 1
  disk_size             = 10
  disk_type             = "PD_SSD"
  tier                  = "db-f1-micro"
}

sql_users = {
  name     = "root"
  password = "feloimastun"
}

sql_private_address = {
  address_type  = "INTERNAL"
  name          = "threetier-mysql-db-private-ip"
  prefix_length = 16
  purpose       = "VPC_PEERING"
}

# ------------------------------------------
# COMPUTE MODULE
# ------------------------------------------

vm_config = {
  machine_type   = "f1-micro"
  name           = "postgres-vm"
  startup_script = "apt-get update && apt-get install -y postgresql postgresql-contrib  && service postgresql start && sudo -u postgres psql -c \"CREATE DATABASE demo_db;\" && sudo -u postgres psql -c \"CREATE USER felo WITH PASSWORD 'feloimastun';\" && sudo -u postgres psql -c \"GRANT ALL PRIVILEGES ON DATABASE demo_db TO felo;\"" # Change to your startup script
  tags           = ["postgres-vm"]
  zone           = "value"

  network_interface = {
    access_config = {
      nat_ip       = "value"
      network_tier = "value"
    }
    network    = "three-tier-vpc"
    subnetwork = "vmsubnet"
  }

  boot_disk = {
    initialize_params = {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  service_account = {
    scopes = ["cloud-platform"]
  }
}

# ------------------------------------------
# GKE MODULE
# ------------------------------------------

node_pool_attributes = {
  ip_allocation_policy = {
    cluster_secondary_range_name  = "value"
    services_secondary_range_name = "value"
    cluster_ipv4_cidr_block       = "172.17.0.0/18"
    services_ipv4_cidr_block      = "192.168.1.128/25"
    network                       = "three-tier-vpc"
    subnetwork                    = "k8subnet"
  }
  location = "us-east1"
  name     = "threetier-gke-cluster-node-pool"
  node_config = {
    machine_type = "f1-micro"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
    preemptible  = false
  }
  node_count = 1
}

cluster_config = {
  initial_node_count       = 1
  location                 = "us-east1"
  name                     = "three-tier-gke-cluster"
  remove_default_node_pool = false
}

# node_config = {
#   disk_size_gb = 10
#   disk_type = "pd-standard"
#   image_type = "COS"
#   labels = {}
#   local_ssd_count = 0
#   machine_type = "f1-micro"
#   metadata = {}
#   min_cpu_platform = "Intel Haswell"
#   oauth_scopes = [
#     "https://www.googleapis.com/auth/cloud-platform"
#   ]
#   preemptible = false
#   service_account = "default"
#   tags = []
#   taint = []
# }

gke_service_account = {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}