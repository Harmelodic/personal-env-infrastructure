locals {
  cluster_secondary_range_name  = "pods-secondary-range"
  services_secondary_range_name = "services-secondary-range"
}

resource "google_compute_subnetwork" "apps" {
  # checkov:skip=CKV_GCP_26: VPC Flow Logs are a bit pricey - so don't require
  description              = "Subnetwork for applications"
  ip_cidr_range            = local.network_cidr.apps_cluster_nodes
  name                     = "apps"
  private_ip_google_access = true
  project                  = google_project.host.project_id
  network                  = google_compute_network.main.id
  region                   = var.region

  secondary_ip_range {
    ip_cidr_range = local.network_cidr.apps_cluster_pods
    range_name    = local.cluster_secondary_range_name
  }

  secondary_ip_range {
    ip_cidr_range = local.network_cidr.apps_cluster_services
    range_name    = local.services_secondary_range_name
  }

  depends_on = [
    google_compute_shared_vpc_service_project.apps
  ]
}

resource "google_compute_subnetwork_iam_member" "member" {
  project    = google_project.host.project_id
  subnetwork = google_compute_subnetwork.apps.name
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${google_project.apps.number}@cloudservices.gserviceaccount.com"
}
