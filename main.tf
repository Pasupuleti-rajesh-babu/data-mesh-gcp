terraform {
  required_version = ">= 1.8.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.0"
    }
  }

  backend "gcs" {
    bucket = "your-tf-state-bucket-name" # <-- CHANGE THIS
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# GCS Buckets for Raw and Curated Data
module "gcs_raw" {
  source        = "./modules/gcs"
  project_id    = var.project_id
  bucket_name   = "${var.project_id}-raw"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true # For PoC only
}

module "gcs_curated" {
  source        = "./modules/gcs"
  project_id    = var.project_id
  bucket_name   = "${var.project_id}-curated"
  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true # For PoC only
}

# Pub/Sub Topics and Subscriptions for each Domain
module "pubsub" {
  source     = "./modules/pubsub"
  project_id = var.project_id
  domains    = var.domains
}

# BigQuery Datasets for each Domain
module "bigquery" {
  source     = "./modules/bigquery"
  project_id = var.project_id
  region     = var.region
  domains    = var.domains
}

module "monitoring" {
  source            = "./modules/monitoring"
  project_id        = var.project_id
  region            = var.region
  slack_webhook_url = var.slack_webhook_url
} 