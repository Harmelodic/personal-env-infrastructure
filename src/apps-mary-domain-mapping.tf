resource "google_cloud_run_domain_mapping" "default" {
  location = "asia-southeast1"
  name     = "maryvandenberk.com"

  metadata {
    namespace = google_project.apps.project_id
  }

  spec {
    force_override   = true
    route_name       = "mary-website"
    certificate_mode = "AUTOMATIC"
  }
}
