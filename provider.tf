provider "google" {
  region = "us-east1"
  zone   = "us-east1-d"
  # credentials = "davdav-sa.json"
}

terraform {
  backend "gcs" {
    bucket = "tfstate-3-tier-application"
    prefix = "felostate/"
  }
}