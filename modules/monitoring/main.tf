# 1. Create a notification channel for Slack
resource "google_monitoring_notification_channel" "slack_channel" {
  project      = var.project_id
  display_name = "Slack Channel"
  type         = "slack"
  labels = {
    auth_token   = var.slack_webhook_url
    channel_name = "#general"
  }
  enabled = true
}

# 2. Create a logging sink to export logs (e.g., to a central GCS bucket)
resource "google_logging_project_sink" "dataflow_logs_sink" {
  project = var.project_id
  name    = "dataflow-job-logs-sink"
  filter  = "resource.type = \"dataflow_step\""

  # For this PoC, we'll create a dedicated logging bucket.
  # In a real scenario, this might be a central logging project.
  destination = "storage.googleapis.com/${google_storage_bucket.log_bucket.name}"

  # The writer identity needs permissions on the destination bucket.
  unique_writer_identity = true
}

resource "google_storage_bucket" "log_bucket" {
  project       = var.project_id
  name          = "${var.project_id}-dataflow-job-logs"
  location      = var.region
  force_destroy = true # For PoC only
}

resource "google_project_iam_member" "logging_sink_writer" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = google_logging_project_sink.dataflow_logs_sink.writer_identity
}

# 3. Create an alert policy for failed Dataflow jobs
resource "google_monitoring_alert_policy" "dataflow_job_failed" {
  project      = var.project_id
  display_name = "Dataflow Job Failed"
  combiner     = "OR"

  conditions {
    display_name = "Job status is FAILED"
    condition_threshold {
      filter          = "metric.type=\"dataflow.googleapis.com/job/job_status\" AND metric.label.job_status=\"JOB_STATUS_FAILED\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.slack_channel.id
  ]

  documentation {
    content   = "A Dataflow job has failed. Please check the logs for details."
    mime_type = "text/markdown"
  }
} 