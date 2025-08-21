resource "random_integer" "host_project_suffix" {
  min = 1
  max = 999999
}

resource "google_project" "host" {
  auto_create_network = false
  billing_account     = data.google_billing_account.my_billing_account.id
  folder_id           = google_folder.env.id
  name                = "personal-${terraform.workspace}-host"
  project_id          = "personal-${terraform.workspace}-host-${random_integer.host_project_suffix.result}"
}

resource "google_project_iam_audit_config" "host" {
  project = google_project.host.id
  service = "allServices"

  audit_log_config {
    log_type = "ADMIN_READ"
  }

  audit_log_config {
    log_type = "DATA_READ"
  }

  audit_log_config {
    log_type = "DATA_WRITE"
  }
}

resource "google_project_service" "host_apis" {
  for_each = toset([
    "cloudbilling.googleapis.com",      # Required for hooking project to Cloud Billing
    "container.googleapis.com",         # Required for using Google Kubernetes Engine in Service projects
    "dns.googleapis.com",               # Required for managing DNS zones
    "domains.googleapis.com",           # Required for registering domain names
    "dns.googleapis.com",               # Required for handling DNS
    "iam.googleapis.com",               # Required for handling IAM permissions
    "servicenetworking.googleapis.com", # Required for using private Cloud SQL databases
  ])

  disable_dependent_services = true
  disable_on_destroy         = true
  project                    = google_project.host.id
  service                    = each.key
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = google_project.host.project_id
}

resource "google_project_iam_member" "automation_host_project_perms" {
  for_each = toset([
    "roles/billing.projectManager",
    "roles/owner",
  ])

  member  = "serviceAccount:${data.google_service_account.automation.email}"
  project = google_project.host.project_id
  role    = each.key
}
