output "environment_id" {
  description = "The ID of the Cloud Composer environment."
  value       = google_composer_environment.main.id
} 