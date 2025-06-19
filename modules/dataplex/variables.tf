variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for Dataplex resources."
  type        = string
}

variable "domains" {
  description = "A list of data domains to create Dataplex assets for."
  type        = list(string)
} 