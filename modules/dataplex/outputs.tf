output "lake_id" {
  description = "The ID of the Dataplex lake."
  value       = google_dataplex_lake.primary_lake.id
} 