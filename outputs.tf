output "gcs_raw_bucket_name" {
  description = "The name of the GCS bucket for raw data."
  value       = module.gcs_raw.bucket_name
}

output "gcs_curated_bucket_name" {
  description = "The name of the GCS bucket for curated data."
  value       = module.gcs_curated.bucket_name
}

output "pubsub_topic_ids" {
  description = "A map of domain to Pub/Sub topic IDs."
  value       = module.pubsub.topic_ids
}

output "bigquery_dataset_ids" {
  description = "A map of domain and layer to BigQuery dataset IDs."
  value       = module.bigquery.dataset_ids
}

output "monitoring_slack_channel_id" {
  description = "The ID of the monitoring Slack notification channel."
  value       = module.monitoring.slack_notification_channel_id
} 