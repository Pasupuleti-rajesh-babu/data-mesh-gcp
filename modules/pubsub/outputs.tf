output "topic_ids" {
  description = "A map of domain to Pub/Sub topic IDs."
  value       = { for domain, topic in google_pubsub_topic.topics : domain => topic.id }
}

output "topic_names" {
  description = "A map of domain to Pub/Sub topic names."
  value       = { for domain, topic in google_pubsub_topic.topics : domain => topic.name }
}

output "subscription_ids" {
  description = "A map of domain to Pub/Sub subscription IDs."
  value       = { for domain, sub in google_pubsub_subscription.subscriptions : domain => sub.id }
}

output "subscription_names" {
  description = "A map of domain to Pub/Sub subscription names."
  value       = { for domain, sub in google_pubsub_subscription.subscriptions : domain => sub.name }
} 