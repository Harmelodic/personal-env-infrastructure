resource "google_project_iam_member" "workload_permissions" {
  for_each = toset([
    "roles/cloudsql.instanceUser",
    "roles/cloudsql.client"
  ])

  member  = "serviceAccount:${var.workload_service_account_email}"
  project = var.project_id
  role    = each.value
}
