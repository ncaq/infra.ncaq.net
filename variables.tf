variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "mackerel_webhook_url" {
  description = "Webhook URL for Mackerel notifications"
  type        = string
  sensitive   = true
}
