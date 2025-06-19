variable "project_id" {
  description = "The ID of the project in which to create the BigQuery datasets."
  type        = string
}

variable "region" {
  description = "The region for the BigQuery datasets."
  type        = string
}

variable "domains" {
  description = "A list of data domains to create datasets for."
  type        = list(string)
}

variable "layers" {
  description = "A list of data layers (e.g., raw, curated)."
  type        = list(string)
  default     = ["raw", "curated"]
}

variable "dataset_delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when the dataset is destroyed."
  type        = bool
  default     = true # For PoC only
} 