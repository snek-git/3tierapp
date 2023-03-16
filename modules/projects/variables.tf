variable "project_name" {
  type = string
}
variable "project_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "billing_account" {
  type = string
}
variable "auto_create_network" {
  type = bool
}
variable "services" {
  type = list(string)
}
