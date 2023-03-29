data "google_organization" "organisation" {
  domain = var.org_domain
}

# ------------------------------------------
# TERRAFORM SERVICE ACCOUNT MODULE
# ------------------------------------------

module "terraform_service_account" {
  source     = "./modules/terraform-sa-module"
  project_id = var.terraform_service_account_project_id

  terraform_service_account_id           = var.terraform_service_account_id
  terraform_service_account_display_name = var.terraform_service_account_display_name
  organization_id                        = data.google_organization.organisation.org_id
  organization_roles                     = var.terraform_service_account_iam_roles
}

# ------------------------------------------
# FOLDER MODULE
# ------------------------------------------

module "folders" {
  depends_on = [
    module.terraform_service_account
  ]
  source     = "./modules/folders/"
  folder_map = var.folder_configuration
  org_id     = data.google_organization.organisation.org_id
}

# ------------------------------------------
# PROJECTS MODULE
# ------------------------------------------

module "projects" {
  depends_on = [
    module.folders
  ]
  source = "./modules/projects/"

  for_each = var.dynamic_project_config

  auto_create_network = each.value.auto_create_network
  billing_account     = each.value.billing_account
  folder_id           = module.folders.names_to_ids[each.value.folder_name]
  project_id          = each.key
  project_name        = each.value.name
  services            = each.value.services
}

# ------------------------------
# NETWORK MODULE
# ------------------------------

module "network" {
  depends_on = [
    module.projects,
    module.folders
  ]
  source = "./modules/network"

  network_config        = var.network_config
  dynamic_subnet_config = var.dynamic_subnet_config
  host_project_id       = var.host_project_id
  service_project_ids   = var.service_project_ids
}

# ------------------------------------------
# SQL MODULE
# ------------------------------------------

module "sql" {
  depends_on = [
    module.network
  ]
  source = "./modules/sql"

  service_project_id  = var.service_project_id
  host_project_id     = var.host_project_id
  sql_config          = var.sql_config
  sql_ip_config       = var.sql_ip_config
  sql_settings        = var.sql_settings
  sql_users           = var.sql_users
  sql_private_address = var.sql_private_address
}



# ------------------------------------------
# COMPUTE MODULE
# ------------------------------------------

module "compute" {
  depends_on = [
    module.network
  ]
  source = "./modules/compute"

  host_project_id    = var.host_project_id
  service_project_id = var.service_project_id
  vm_config          = var.vm_config
}


# ------------------------------------------
# GKE MODULE
# ------------------------------------------

module "gke" {
  depends_on = [
    module.network
  ]
  source = "./modules/gke"

  host_project_id      = var.host_project_id
  service_project_id   = var.service_project_id
  node_pool_attributes = var.node_pool_attributes
  cluster_config       = var.cluster_config
  gke_service_account  = var.gke_service_account
  vpc_self_link        = module.network.self_link
  subnetwork_self_link = module.network.subnetwork_self_link
}

