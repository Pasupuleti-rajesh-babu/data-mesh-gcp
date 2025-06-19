resource "google_pubsub_topic" "topics" {
  for_each = toset(var.domains)

  project = var.project_id
  name    = "${each.key}-events"

  labels = {
    "data-mesh-domain" = each.key
  }
}

resource "google_pubsub_subscription" "subscriptions" {
  for_each = toset(var.domains)

  project = var.project_id
  name    = "${each.key}-events-subscription-dataflow"
  topic   = google_pubsub_topic.topics[each.key].id

  ack_deadline_seconds = 600

  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering = false

  labels = {
    "data-mesh-domain" = each.key
  }
}

resource "google_pubsub_topic_iam_member" "publisher" {
  for_each = toset(var.domains)

  project = var.project_id
  topic   = google_pubsub_topic.topics[each.key].name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_pubsub_subscription_iam_binding" "subscriber" {
  for_each = { for domain, members in var.subscribers : domain => members if length(members) > 0 }

  project      = var.project_id
  subscription = google_pubsub_subscription.subscriptions[each.key].id
  role         = "roles/pubsub.subscriber"
  members      = each.value
}

data "google_project" "project" {
  project_id = var.project_id
} 