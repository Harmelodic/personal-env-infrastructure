resource "google_service_account" "mary_website_deployment" {
  account_id   = "mary-website-deployment"
  description  = "Service Account used for deploying Mary's Website"
  disabled     = false
  display_name = "Mary Website Deployment"
  project      = google_project.apps.project_id
}
