resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.zone_id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = var.zone_id
  setting_id = "ssl"
  value      = "full"
}

resource "cloudflare_zone_setting" "cache_level" {
  zone_id    = var.zone_id
  setting_id = "cache_level"
  value      = "aggressive"
}

resource "cloudflare_zone_setting" "browser_cache_ttl" {
  zone_id    = var.zone_id
  setting_id = "browser_cache_ttl"
  value      = 0
}

resource "cloudflare_zone_setting" "always_online" {
  zone_id    = var.zone_id
  setting_id = "always_online"
  value      = "on"
}

resource "cloudflare_zone_setting" "browser_check" {
  zone_id    = var.zone_id
  setting_id = "browser_check"
  value      = "off"
}

resource "cloudflare_zone_setting" "challenge_ttl" {
  zone_id    = var.zone_id
  setting_id = "challenge_ttl"
  value      = 31536000
}
