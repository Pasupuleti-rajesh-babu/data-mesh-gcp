output "slack_notification_channel_id" {
  description = "The ID of the Slack notification channel."
  value       = google_monitoring_notification_channel.slack_channel.id
}

output "logging_sink_writer_identity" {
  description = "The service account identity for the logging sink."
  value       = google_logging_project_sink.dataflow_logs_sink.writer_identity
} 