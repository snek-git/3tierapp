resource "google_service_account" "terraform_service_account" {
  # This resource is used to create a service account for Cloud Storage
  project      = var.project_id
  account_id   = var.terraform_service_account_id
  display_name = var.terraform_service_account_display_name
}

resource "google_organization_iam_member" "organization" {
  org_id  = var.organization_id

  for_each = toset(var.organization_roles)
  role    = each.key

  member  = "serviceAccount:${google_service_account.terraform_service_account.email}"
}
