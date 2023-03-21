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

network_config = {
  name                    = "three-tier-vpc"
  project_id              = "felo-task-host-project" # Change to your project ID
  description             = "Host VPC"
  auto_create_subnetworks = false,
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
