variable "cloudflare" {
  description = "Cloudflare configuration"
  type = object({
    zone_id    = string
    account_id = string
  })
}
