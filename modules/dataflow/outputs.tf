output "job_ids" {
  description = "A map of domain to Dataflow job IDs."
  value       = { for domain, job in google_dataflow_flex_template_job.streaming_jobs : domain => job.id }
} 