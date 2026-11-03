resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.zone_id
  setting_id = "always_use_https"
  value      = "on"
}

# HSTS Preloadの申請条件であるmax-age 1年以上、includeSubDomains、preloadを満たします。
# 条件を満たさなくなるとリストから外されるので、値を下げる時は注意してください。
resource "cloudflare_zone_setting" "security_header" {
  zone_id    = var.zone_id
  setting_id = "security_header"
  value = {
    strict_transport_security = {
      enabled            = true
      max_age            = 31536000
      include_subdomains = true
      preload            = true
      nosniff            = true
    }
  }
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = var.zone_id
  setting_id = "ssl"
  value      = "strict"
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

# 個別に理由を説明する必要が無く、現在の値を固定するだけの設定。
# 非推奨のminify, mobile_redirect, tls_1_2_onlyと、
# 一時的に切り替えるdevelopment_modeは含めない。
locals {
  zone_settings = {
    "0rtt"                    = "on"
    automatic_https_rewrites  = "off"
    brotli                    = "on"
    ciphers                   = []
    cname_flattening          = "flatten_at_root"
    early_hints               = "on"
    ech                       = "on"
    edge_cache_ttl            = 7200
    email_obfuscation         = "off"
    filter_logs_to_cloudflare = "off"
    hotlink_protection        = "off"
    http3                     = "on"
    ip_geolocation            = "off"
    ipv6                      = "on"
    log_to_cloudflare         = "on"
    max_upload                = 100
    min_tls_version           = "1.0"
    opportunistic_encryption  = "on"
    opportunistic_onion       = "on"
    orange_to_orange          = "off"
    pq_keyex                  = "on"
    privacy_pass              = "on"
    pseudo_ipv4               = "off"
    replace_insecure_js       = "on"
    rocket_loader             = "off"
    security_level            = "essentially_off"
    server_side_exclude       = "off"
    tls_1_3                   = "zrt"
    tls_client_auth           = "off"
    visitor_ip                = "on"
    waf                       = "off"
    websockets                = "on"
  }
}

resource "cloudflare_zone_setting" "pinned" {
  for_each = local.zone_settings

  zone_id    = var.zone_id
  setting_id = each.key
  value      = each.value
}

# 同じ設定を2つのリソースで管理すると、
# applyのたびに互いの値を上書きして差分が収まらなくなる。
check "zone_settings_not_duplicated" {
  assert {
    condition = length(setintersection(keys(local.zone_settings), [
      cloudflare_zone_setting.always_online.setting_id,
      cloudflare_zone_setting.always_use_https.setting_id,
      cloudflare_zone_setting.browser_cache_ttl.setting_id,
      cloudflare_zone_setting.browser_check.setting_id,
      cloudflare_zone_setting.cache_level.setting_id,
      cloudflare_zone_setting.challenge_ttl.setting_id,
      cloudflare_zone_setting.security_header.setting_id,
      cloudflare_zone_setting.ssl.setting_id,
    ])) == 0
    error_message = "local.zone_settingsのキーが個別のcloudflare_zone_settingリソースと重複しています。"
  }
}
