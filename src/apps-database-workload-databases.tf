module "apps_database_blog_database" {
  source                            = "./workload-database"
  database_instance_connection_name = google_sql_database_instance.apps.connection_name
  database_instance_name            = google_sql_database_instance.apps.name
  namespace                         = module.harmelodic_blog_workload.namespace
  project_id                        = google_project.apps.project_id
  workload_service_account_email    = module.harmelodic_blog_workload.google_service_account.email
  workload_name                     = module.harmelodic_blog_workload.name
}
