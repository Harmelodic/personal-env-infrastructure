# General Variables
region = "europe-north1"

# Apps Variables
apps_database_disk_size         = 10
apps_database_location          = "europe-north1"
apps_database_machine_tier      = "db-f1-micro"
apps_gke_location               = "europe-north1-b"
apps_gke_node_count             = 5
apps_gke_node_pool_machine_type = "e2-small"

apps_gke_node_locations = [
  "europe-north1-b"
]

# Domain Variables
apps_harmelodic_dns_name = "harmelodic.com"
