terraform {
  required_version = ">=1.1.8"

  backend "gcs" {
    bucket = "harmelodic-tfstate"
    prefix = "personal-env-infrastructure"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.11.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
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
