data "google_projects" "personal-artifact_lookup" {
  filter = "name:personal-artifacts lifecycleState:ACTIVE"
}

data "google_project" "personal_artifacts" {
  project_id = data.google_projects.personal-artifact_lookup.projects[0].project_id
}

# Grant serverless access to Mary Website Artifacts for deploying Mary's website using Cloud Run
resource "google_artifact_registry_repository_iam_member" "apps_compute_mary_website" {
  project    = data.google_project.personal_artifacts.project_id
  location   = "asia-southeast1"
  repository = "mary-website"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${google_project.apps.number}@serverless-robot-prod.iam.gserviceaccount.com"
}
