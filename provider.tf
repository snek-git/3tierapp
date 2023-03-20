provider "google" {
  credentials = "three-tier-app-main-f-49eb9911a593.json"
}

terraform {
  backend "gcs" {
    bucket = "three-tier-app-tf-backend"
    prefix = "state/"
  }
}