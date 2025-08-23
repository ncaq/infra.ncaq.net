resource "cloudflare_page_rule" "cdn_cache" {
  zone_id = var.zone_id
  target  = "cdn.ncaq.net/*"
  actions = {
    cache_level = "cache_everything"
  }
  priority = 2
  status   = "active"
}
