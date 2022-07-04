data "google_active_folder" "personal" {
  display_name = "Personal"
  parent       = data.google_organization.harmelodic_com.name
}

resource "google_folder" "env" {
  display_name = terraform.workspace
  parent       = data.google_active_folder.personal.id
}

resource "google_folder_iam_member" "folder_automation_perms" {
  for_each = toset([
    "roles/compute.xpnAdmin",
  ])

  member = "serviceAccount:${data.google_service_account.automation.email}"
  folder = google_folder.env.id
  role   = each.key
}
