resource "google_compute_network" "main" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  description                     = "Main VPC network for personal projects"
  name                            = "main"
  routing_mode                    = "REGIONAL"
  project                         = google_project.host.project_id
}

locals {
  network_cidr = {
    apps_cluster_nodes    = "10.0.0.0/16"
    apps_cluster_pods     = "10.1.0.0/16"
    apps_cluster_services = "10.2.0.0/16"
    apps_cluster_masters  = "10.3.0.0/28"
  }
}
