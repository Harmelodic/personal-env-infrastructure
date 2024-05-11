resource "google_storage_bucket" "web_static" {
  // Prefixing name with "harmelodic-" because Storage Buckets are globally unique.
  name                        = "harmelodic-web-static-${terraform.workspace}"
  location                    = var.region
  project                     = google_project.apps.project_id
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    environment = terraform.workspace
  }

  autoclass {
    // Opportunity for Google to figure out if I can save some money.
    enabled                = true
    terminal_storage_class = "NEARLINE"
  }

  cors {
    // Allow fetching the data, cache the CORS
    origin          = ["*"]
    method          = ["GET", "OPTIONS"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  versioning {
    // Don't need versioning for static files
    enabled = false
  }
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.web_static.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
