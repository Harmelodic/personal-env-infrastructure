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
