resource "kubernetes_config_map" "connection" {
  metadata {
    name      = "${var.workload_name}-database-connection"
    namespace = var.namespace
  }

  data = {
    database                 = google_sql_database.database.name
    instance-connection-name = var.database_instance_connection_name
    username                 = google_sql_user.sql_user.name
  }
}

output "connection_config_map_name" {
  value = kubernetes_config_map.connection.metadata.0.name
}

output "connection_config_map_namespace" {
  value = kubernetes_config_map.connection.metadata.0.namespace
}
