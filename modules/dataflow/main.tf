resource "google_dataflow_flex_template_job" "streaming_jobs" {
  for_each = var.domain_configs

  project                 = var.project_id
  region                  = var.region
  name                    = "${each.key}-streaming-job"
  container_spec_gcs_path = each.value.template_gcs_path
  service_account_email   = var.service_account_email

  parameters = {
    project_id          = var.project_id
    subscription        = each.value.subscription_name
    raw_bucket_path     = each.value.raw_bucket_name
    curated_bucket_path = each.value.curated_bucket_name
  }

  on_delete = "cancel"
} 