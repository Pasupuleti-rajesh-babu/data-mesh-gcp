variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The Google Cloud region."
  type        = string
  default     = "us-central1"
}

variable "env" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for alerts."
  type        = string
  sensitive   = true
  default     = ""
}

variable "domains" {
  description = "A list of data domains."
  type        = list(string)
  default     = ["finance", "marketing", "operations"]
} 