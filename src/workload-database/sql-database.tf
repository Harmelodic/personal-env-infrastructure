resource "google_sql_database" "database" {
  charset   = "UTF8"
  collation = "en_US.UTF8"
  instance  = var.database_instance_name
  name      = var.workload_name
  project   = var.project_id
}
