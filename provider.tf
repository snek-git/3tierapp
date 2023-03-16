provider "google" {
  credentials = "organistation-test-335d12c5a6c6.json"
}

terraform {
  backend "gcs" {
    bucket = "felo-state-backend"
    prefix = "state/"
  }
}