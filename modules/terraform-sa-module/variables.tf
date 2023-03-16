variable "project_id" {
  type = string
}
variable "terraform_service_account_id" {
  type = string
}
variable "terraform_service_account_display_name" {
  type = string
}

variable "organization_roles" {
  type = list(string)
}

variable "organization_id" {
  type = string
}
