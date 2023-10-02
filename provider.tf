terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.83.0"
    }
  }
}

provider "google" {
  project     = "terrafor4gcp"
  credentials = file("terrafor4gcp-41e345601b7d.json")
  region      = "us-central1"
}
