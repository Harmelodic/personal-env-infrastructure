terraform {
  required_version = ">=1.1.8"

  backend "gcs" {
    bucket = "harmelodic-tfstate"
    prefix = "personal-env-infrastructure"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.35.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.34.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.2"
    }
  }
}

variable "region" {
  default     = "europe-north1"
  description = "GCP Region"
  sensitive   = true
  type        = string
}

provider "google" {
  region = var.region
}

provider "google-beta" {
  region = var.region
}
