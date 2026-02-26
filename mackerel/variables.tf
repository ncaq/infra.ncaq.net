variable "slack_url" {
  description = "Slack-compatible webhook URL for Mackerel notifications (e.g., Discord /slack endpoint)"
  type        = string
  sensitive   = true
}
