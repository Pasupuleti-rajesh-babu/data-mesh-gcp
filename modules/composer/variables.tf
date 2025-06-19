variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for the Composer environment."
  type        = string
}

variable "environment_name" {
  description = "The name of the Cloud Composer environment."
  type        = string
  default     = "data-mesh-composer"
} 