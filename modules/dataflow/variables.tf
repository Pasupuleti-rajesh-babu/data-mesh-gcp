variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for Dataflow jobs."
  type        = string
}

variable "domain_configs" {
  description = "A map of domain configurations for Dataflow jobs."
  type = map(object({
    template_gcs_path   = string
    subscription_name   = string
    raw_bucket_name     = string
    curated_bucket_name = string
  }))
}

variable "service_account_email" {
  description = "The service account email to run the Dataflow jobs."
  type        = string
} 