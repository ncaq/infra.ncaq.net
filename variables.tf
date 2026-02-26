variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "mackerel_slack_url" {
  description = "Slack-compatible webhook URL for Mackerel notifications (e.g., Discord /slack endpoint)"
  type        = string
  sensitive   = true
}
