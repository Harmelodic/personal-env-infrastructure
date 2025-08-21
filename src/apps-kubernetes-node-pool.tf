variable "apps_gke_node_count" {
  description = "The number of nodes on the Apps cluster"
  sensitive   = true
  type        = number
}

variable "apps_gke_node_locations" {
  description = "The list of zones in which the node pool's nodes should be located"
  sensitive   = true
  type        = list(string)
}

variable "apps_gke_node_pool_machine_type" {
  description = "Machine size for GKE node pool"
  sensitive   = true
  type        = string
}

resource "google_service_account" "gke_node_pool_apps" {
  account_id                   = "gke-node-pool-apps"
  create_ignore_already_exists = true
  display_name                 = "GKE Node Pool Apps"
  description                  = "The service account for the GKE Node Pool used for Apps"
  project                      = google_project.apps.project_id
}

# Grant node pool access to artifact registry repository for deploying harmelodic apps
resource "google_artifact_registry_repository_iam_member" "apps_compute_harmelodic" {
  project    = data.google_project.personal_artifacts.project_id
  location   = var.region
  repository = "harmelodic"
  role       = "roles/artifactregistry.reader"
  member     = google_service_account.gke_node_pool_apps.member
}

resource "google_container_node_pool" "apps" {
  cluster        = google_container_cluster.apps.name
  location       = var.apps_gke_location
  name           = "apps"
  node_count     = var.apps_gke_node_count
  node_locations = var.apps_gke_node_locations
  project        = google_project.apps.project_id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    disk_size_gb    = 100
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    local_ssd_count = 0
    machine_type    = var.apps_gke_node_pool_machine_type
    preemptible     = true
    service_account = google_service_account.gke_node_pool_apps.email

    labels = {
      environment = terraform.workspace
    }

    metadata = {
      disable-legacy-endpoints = true
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = [
      terraform.workspace
    ]

    shielded_instance_config {
      enable_integrity_monitoring = true
      enable_secure_boot          = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  upgrade_settings {
    max_surge       = 2
    max_unavailable = 1
  }
}
