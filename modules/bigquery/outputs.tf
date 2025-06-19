output "dataset_ids" {
  description = "A map of <domain>_<layer> to BigQuery dataset IDs."
  value       = { for k, v in google_bigquery_dataset.domain_datasets : k => v.id }
}

output "analytics_dataset_id" {
  description = "The ID of the central analytics dataset."
  value       = google_bigquery_dataset.analytics.id
}

output "raw_external_table_ids" {
  description = "A map of domain to the raw external BigQuery table ID."
  value       = { for k, v in google_bigquery_table.raw_external_tables : k => v.id }
} 