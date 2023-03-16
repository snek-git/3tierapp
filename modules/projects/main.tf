resource "google_project" "dynamic_project" {
  name       = var.project_name
  project_id = var.project_id

  folder_id           = var.folder_id
  billing_account     = var.billing_account
  auto_create_network = var.auto_create_network
}

resource "google_project_service" "project" {
  depends_on = [google_project.dynamic_project]
  project    = var.project_id

  for_each = toset(var.services)
  service  = each.key

  disable_dependent_services = true
}

#resource "null_resource" "enable_service_usage_api" {
#  for_each = toset(var.services)
#  provisioner "local-exec" {
#    command = "gcloud services enable ${each.key} --project ${var.project_id}"
#  }
#  depends_on = [google_project.dynamic_project]
#}
