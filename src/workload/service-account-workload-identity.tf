resource "google_service_account" "workload" {
  project    = var.project_id
  account_id = "${var.namespace}-${var.name}"
}

output "google_service_account" {
  value = google_service_account.workload
}

resource "kubernetes_service_account" "workload" {
  metadata {
    name      = var.name
    namespace = var.namespace

    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.workload.email
    }
  }
}

output "kubernetes_service_account" {
  value = kubernetes_service_account.workload
}

resource "google_service_account_iam_member" "cert_manager_workload_identity" {
  member = join("", [
    "serviceAccount:",
    var.project_id,
    ".svc.id.goog[",
    kubernetes_service_account.workload.metadata.0.namespace,
    "/",
    kubernetes_service_account.workload.metadata.0.name,
    "]"
  ])
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.workload.name
}
