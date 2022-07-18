terraform {
  required_version = ">=1.1.8"

  backend "gcs" {
    bucket = "harmelodic-tfstate"
    prefix = "personal-env-infrastructure"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.29.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
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

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.apps.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.apps.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.apps.endpoint}"
    cluster_ca_certificate = base64decode(google_container_cluster.apps.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}
