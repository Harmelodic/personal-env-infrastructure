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
    google_project_service.apps_apis,
    google_project_service.host_apis,
    google_service_networking_connection.private_vpc_connection
  ]

  # checkov:skip=CKV_GCP_79: TODO: Waiting on GCP to fix their later versions of Postgres Cloud SQL.
  database_version    = "POSTGRES_14"
  deletion_protection = false
  name                = "apps"
  project             = google_project.apps.project_id
  region              = var.apps_database_location

  settings {
    activation_policy     = "ALWAYS"
    availability_type     = "ZONAL"
    tier                  = var.apps_database_machine_tier
    disk_autoresize       = true
    disk_autoresize_limit = 0
    disk_size             = var.apps_database_disk_size
    disk_type             = "PD_SSD"
    pricing_plan          = "PER_USE"

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

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name  = "log_connections"
      value = "on"
    }

    database_flags {
      name  = "log_disconnections"
      value = "on"
    }

    database_flags {
      name  = "log_duration"
      value = "on"
    }

    database_flags {
      name  = "log_hostname"
      value = "on"
    }

    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }

    # checkov:skip=CKV_GCP_55: TODO: Review if applicable
    # checkov:skip=CKV_GCP_109: TODO: Review if applicable
    database_flags {
      name  = "log_min_messages"
      value = "warning"
    }

    database_flags {
      name  = "log_statement"
      value = "all"
    }

    # checkov:skip=CKV_GCP_110: TODO: Review if applicable
    database_flags {
      name  = "pgaudit.log"
      value = "all"
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
      ssl_mode        = "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    }

    maintenance_window {
      day          = 2 # Tuesday
      hour         = 3 # 2AM (UTC)
      update_track = "stable"
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }
}
