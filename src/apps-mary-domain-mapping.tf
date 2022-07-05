variable "apps_mary_website_dns_name" {
  type        = string
  description = "The domain name for mary-website"
}


resource "google_cloud_run_domain_mapping" "default" {
  location = "asia-southeast1"
  name     = var.apps_mary_website_dns_name
  project  = google_project.apps.project_id

  metadata {
    namespace = google_project.apps.project_id
  }

  spec {
    force_override   = true
    route_name       = "mary-website"
    certificate_mode = "AUTOMATIC"
  }
}
