variable "apps_harmelodic_dns_name" {
  description = "Harmelodic domain name used for this environment"
  sensitive   = true
  type        = string
}

resource "google_dns_managed_zone" "harmelodic_com" {
  depends_on = [
    google_project_service.host_apis
  ]

  description = "Managed Zone for ${var.apps_harmelodic_dns_name}"
  dns_name    = "${var.apps_harmelodic_dns_name}."
  name        = replace(var.apps_harmelodic_dns_name, ".", "-")
  project     = google_project.host.project_id

  dnssec_config {
    state = "on"
  }

  labels = {
    environment = terraform.workspace
  }
}

resource "google_dns_record_set" "harmelodic_com_a" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "A"

  rrdatas = [
    "185.199.108.153", # GitHub Pages
    "185.199.109.153", # GitHub Pages
    "185.199.110.153", # GitHub Pages
    "185.199.111.153"  # GitHub Pages
  ]
}

resource "google_dns_record_set" "harmelodic_com_cname" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "www.${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "CNAME"

  rrdatas = [
    "harmelodic.github.io."
  ]
}

resource "google_dns_record_set" "argo_cd_harmelodic_com_a" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "argo-cd.${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "A"

  rrdatas = [
    "35.228.252.4"
  ]
}

resource "google_dns_record_set" "pact_harmelodic_com_a" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "pact.${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "A"

  rrdatas = [
    "35.228.252.4"
  ]
}

resource "google_dns_record_set" "harmelodic_com_mx" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 3600
  type         = "MX"

  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}

resource "google_dns_record_set" "harmelodic_com_txt" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "TXT"

  rrdatas = [
    "google-site-verification=jXVba9WLVzprbkW4EpS3vtWL5-2YH03AwSc8sprMfSU",  # Google Domains
    "keybase-site-verification=sDm605nNkmQuRsuciUxr9KmDkMgBVUKD5Ea38C_8L4w", # Keybase
    "OSSRH-92980",                                                           # Maven Repository - https://issues.sonatype.org/browse/OSSRH-92980
  ]
}

resource "google_dns_record_set" "atproto_harmelodic_com_txt" {
  managed_zone = google_dns_managed_zone.harmelodic_com.name
  name         = "_atproto.${var.apps_harmelodic_dns_name}."
  project      = google_project.host.project_id
  ttl          = 300
  type         = "TXT"

  rrdatas = [
    "did=did:plc:simdj7zyuj4g3vuklsj6nqsq" # Bluesky
  ]
}
