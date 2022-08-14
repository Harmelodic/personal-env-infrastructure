resource "google_compute_router" "egress_nat" {
  name    = "egress-nat"
  network = google_compute_network.main.id
  project = google_project.host.project_id
  region  = var.region
}

resource "google_compute_router_nat" "egress" {
  name                               = "egress"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.egress_nat.name
  project                            = google_project.host.project_id
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_route" "main_default_internet_gateway" {
  dest_range       = "0.0.0.0/0"
  name             = "default-internet-gateway"
  network          = google_compute_network.main.id
  next_hop_gateway = "default-internet-gateway"
  project          = google_project.host.project_id
}
