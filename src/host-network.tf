resource "google_compute_network" "main" {
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  description                     = "Main VPC network for personal projects"
  name                            = "main"
  routing_mode                    = "REGIONAL"
  project                         = google_project.host.project_id
}

resource "google_compute_route" "main_default_internet_gateway" {
  dest_range       = "0.0.0.0/0"
  name             = "default-internet-gateway"
  network          = google_compute_network.main.id
  next_hop_gateway = "default-internet-gateway"
  project          = google_project.host.project_id
}

resource "google_compute_global_address" "private_google_services_access" {
  address_type  = "INTERNAL"
  description   = "A global address for Private Google Services Access"
  ip_version    = "IPV4"
  name          = "private-google-services-access"
  network       = google_compute_network.main.id
  prefix_length = 20
  project       = google_project.host.project_id
  purpose       = "VPC_PEERING"
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.main.id
  reserved_peering_ranges = [google_compute_global_address.private_google_services_access.name]
  service                 = "servicenetworking.googleapis.com"
}
