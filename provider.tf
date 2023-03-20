provider "google" {
  # credentials = "key.json"
}

terraform {
  backend "gcs" {
    bucket = "three-tier-app-tf-backend"
    prefix = "state/"
  }
}