variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "bigquery_datasets" {
  description = "A map of BigQuery datasets to grant permissions on."
  type        = map(string)
  default     = {}
}

variable "viewers" {
  description = "A list of IAM members to grant BigQuery Data Viewer role."
  type        = list(string)
  default     = []
} 