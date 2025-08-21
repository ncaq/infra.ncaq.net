# ゾーン設定
resource "cloudflare_zone_settings_override" "ncaq_net" {
  zone_id = var.zone_id

  settings {
    # セキュリティ設定
    always_use_https = "on"
    ssl              = "full"

    # キャッシュ設定
    cache_level       = "aggressive"
    browser_cache_ttl = 0
    always_online     = "on"

    # セキュリティチャレンジを弱める
    browser_check = "off"
    challenge_ttl = 31536000
  }
}
