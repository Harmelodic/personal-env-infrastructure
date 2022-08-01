variable "name" {
  description = "Name of the Workload"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the workload's Kubernetes Service Account"
  type = string
}

variable "project_id" {
  description = "Project ID of the Project the Workload will be deployed to"
  type = string
}

output "name" {
  value = var.name
}

output "namespace" {
  value = var.namespace
}
