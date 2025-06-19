variable "project_id" {
  description = "The ID of the project in which to create the Pub/Sub resources."
  type        = string
}

variable "domains" {
  description = "A list of data domains to create topics for."
  type        = list(string)
}

variable "subscribers" {
  description = "A map of domain to a list of IAM members who can subscribe."
  type        = map(list(string))
  default     = {}
} 