resource "cloudflare_universal_ssl_setting" "ncaq_net" {
  zone_id = var.zone_id
  enabled = true
}

resource "cloudflare_total_tls" "ncaq_net" {
  zone_id = var.zone_id
  enabled = false
}

resource "cloudflare_authenticated_origin_pulls_settings" "ncaq_net" {
  zone_id = var.zone_id
  enabled = false
}
