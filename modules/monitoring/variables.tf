variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for monitoring resources."
  type        = string
}

variable "slack_webhook_url" {
  description = "The webhook URL for Slack notifications."
  type        = string
  sensitive   = true
}

variable "dataflow_jobs" {
  description = "A map of Dataflow jobs to monitor."
  type        = map(string)
  default     = {}
} 