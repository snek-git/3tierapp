provider "google" {
}

terraform {
  backend "gcs" {
    bucket = "three-tier-app-tf-backend"
    prefix = "state/"
  }
}