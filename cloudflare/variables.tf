variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "seminar_tailscale_ipv4" {
  description = "Tailscale IPv4 address of the seminar device"
  type        = string
}

variable "seminar_tailscale_ipv6" {
  description = "Tailscale IPv6 address of the seminar device"
  type        = string
}
