resource "google_sql_user" "sql_user" {
  deletion_policy = "ABANDON"
  instance        = var.database_instance_name
  name            = trimsuffix(var.workload_service_account_email, ".gserviceaccount.com")
  project         = var.project_id
  type            = "CLOUD_IAM_SERVICE_ACCOUNT"
}

output "sql_username" {
  value = google_sql_user.sql_user.name
}
