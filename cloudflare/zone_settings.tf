# 非推奨のminify, mobile_redirect, tls_1_2_onlyと、
# 一時的に切り替えるdevelopment_modeは含めない。
locals {
  zone_settings = {
    "0rtt"                    = "off" # TLS 1.3の0-RTTで送られるearly dataはリプレイされうる。
    always_online             = "on"
    always_use_https          = "on"
    automatic_https_rewrites  = "off"
    brotli                    = "on"
    browser_cache_ttl         = 0
    browser_check             = "off"
    cache_level               = "aggressive"
    challenge_ttl             = 31536000
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
    min_tls_version           = "1.2" # TLS 1.0と1.1はRFC 8996で廃止されている。
    opportunistic_encryption  = "on"
    opportunistic_onion       = "on"
    orange_to_orange          = "off"
    pq_keyex                  = "on"
    privacy_pass              = "on"
    pseudo_ipv4               = "off"
    replace_insecure_js       = "on"
    rocket_loader             = "off"
    # HSTS Preloadの申請条件であるmax-age 1年以上、includeSubDomains、preloadを満たします。
    # 条件を満たさなくなるとリストから外されるので、値を下げる時は注意してください。
    security_header = {
      strict_transport_security = {
        enabled            = true
        max_age            = 31536000
        include_subdomains = true
        preload            = true
        nosniff            = true # HSTS Preloadの条件ではないが、Cloudflare側がここに配置している。
      }
    }
    # 知識は自由であるべきなので、TorやVPNからの訪問者を排除しない。
    # security_levelを上げるとIPの評判でチャレンジを出すようになり、
    # nixやgitやS3クライアントのようにチャレンジを解けないクライアントが、
    # 共有NATやVPN経由というだけで弾かれる。
    # ボットのノイズを減らしたい時はゾーン全体の閾値を上げずに、
    # WAFのカスタムルールで対象のパスを絞る。
    security_level      = "essentially_off"
    server_side_exclude = "off"
    ssl                 = "strict"
    tls_1_3             = "on" # `zrt`は0-RTT込みの有効化なので、`on`に留める。
    tls_client_auth     = "off"
    visitor_ip          = "on"
    waf                 = "off"
    websockets          = "on"
  }
}

resource "cloudflare_zone_setting" "ncaq_net" {
  for_each = local.zone_settings

  zone_id    = var.zone_id
  setting_id = each.key
  value      = each.value
}
