variable "project_id" {
  description = "The ID of the project in which to create the bucket."
  type        = string
}

variable "bucket_name" {
  description = "The name of the GCS bucket."
  type        = string
}

variable "location" {
  description = "The location of the GCS bucket."
  type        = string
}

variable "storage_class" {
  description = "The storage class of the GCS bucket."
  type        = string
  default     = "STANDARD"
}

variable "versioning" {
  description = "A boolean to enable/disable versioning."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects. If false, the bucket deletion will fail if there are any objects inside it."
  type        = bool
  default     = false
}

variable "uniform_bucket_level_access" {
  description = "Enables uniform bucket-level access."
  type        = bool
  default     = true
} 