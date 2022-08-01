variable "database_instance_connection_name" {
  type        = string
  description = "Instance Connection Name for the Database Instance"
}

variable "database_instance_name" {
  type = string
  description = "Name of the Database Instance"
}

variable "namespace" {
  type = string
  description = "Namespace for where to create Config Map (should be same as where Service is deployed)"
}

variable "project_id" {
  type = string
  description = "Project ID for where the SQL Database Instance is stored"
}

variable "workload_service_account_email" {
  type        = string
  description = "Email of the Google Service Account of the Workload."
}

variable "workload_name" {
  type        = string
  description = "Name of Workload. Used for generating Config Map name"
}
