variable "apps_database_disk_size" {
  description = "Size of storage, in GB, for Apps DB"
  sensitive   = true
  type        = number
}

variable "apps_database_location" {
  description = "Location of Apps DB"
  sensitive   = true
  type        = string
}

variable "apps_database_machine_tier" {
  description = "Type of DB machine for Apps DB"
  sensitive   = true
  type        = string
}

resource "google_sql_database_instance" "apps" {
  depends_on = [
    google_project_service.apps_apis
  ]

  database_version    = "POSTGRES_14"
  deletion_protection = false
  name                = "apps"
  project             = google_project.apps.project_id
  region              = var.apps_database_location

  settings {
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    tier              = var.apps_database_machine_tier
    disk_autoresize   = false
    disk_size         = var.apps_database_disk_size
    disk_type         = "PD_SSD"
    pricing_plan      = "PER_USE"

    backup_configuration {
      enabled  = true
      location = var.apps_database_location

      backup_retention_settings {
        retained_backups = 2
        retention_unit   = "COUNT"
      }
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }

    ip_configuration {
      ipv4_enabled = true
      require_ssl  = true
    }

    maintenance_window {
      day          = 2 # Tuesday
      hour         = 3 # 2AM (UTC)
      update_track = "stable"
    }
  }
}
