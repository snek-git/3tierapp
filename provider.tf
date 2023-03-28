provider "google" {
  region = "us-east1"
  zone   = "us-east1-d"
}

terraform {
  backend "gcs" {
    bucket = "three-tier-app-tf-backend"
    prefix = "state/"
  }
}