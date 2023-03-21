provider "google" {
  credentials = "three-tier-app-main-f-fe7349df4dd4.json"
}

terraform {
  backend "gcs" {
    bucket = "three-tier-app-tf-backend"
    prefix = "state/"
  }
}