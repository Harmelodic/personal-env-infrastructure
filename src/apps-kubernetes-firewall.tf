resource "google_compute_firewall" "control-plane-allow-access-to-nodes" {
  name    = "control-plane-allow-access-to-nodes"
  network = google_compute_network.main.name
  project = google_project.host.project_id

  allow {
    protocol = "tcp"
    ports = [
      "80",    # HTTP
      "443",   # HTTPS
      "10254", # Metrics
      "8443",  # NGINX Validation Webhook
    ]
  }

  source_ranges = [
    local.network_cidr.apps_cluster_masters
  ]

  target_tags = google_container_node_pool.apps.node_config.0.tags
}
