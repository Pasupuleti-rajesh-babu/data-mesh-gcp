locals {
  domain_layers = flatten([
    for domain in var.domains : [
      for layer in var.layers : {
        domain = domain
        layer  = layer
      }
    ]
  ])
}

resource "google_bigquery_dataset" "domain_datasets" {
  for_each = { for dl in local.domain_layers : "${dl.domain}_${dl.layer}" => dl }

  project                    = var.project_id
  dataset_id                 = "${each.value.domain}_${each.value.layer}"
  friendly_name              = "${each.value.domain} ${each.value.layer}"
  location                   = var.region
  delete_contents_on_destroy = var.dataset_delete_contents_on_destroy

  labels = {
    "data-mesh-domain" = each.value.domain
    "data-mesh-layer"  = each.value.layer
  }
}

resource "google_bigquery_dataset" "analytics" {
  project                    = var.project_id
  dataset_id                 = "analytics"
  friendly_name              = "Analytics"
  location                   = var.region
  delete_contents_on_destroy = var.dataset_delete_contents_on_destroy

  labels = {
    "data-mesh-domain" = "analytics"
  }
}

# Example of creating an external table on the raw GCS data
resource "google_bigquery_table" "raw_external_tables" {
  for_each = toset(var.domains)

  project    = var.project_id
  dataset_id = google_bigquery_dataset.domain_datasets["${each.key}_raw"].dataset_id
  table_id   = "${each.key}_events_raw"

  external_data_configuration {
    autodetect    = true
    source_format = "AVRO"
    source_uris   = ["gs://${var.project_id}-raw/${each.key}/*"]
  }
} 