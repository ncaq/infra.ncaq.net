resource "cloudflare_bot_management" "ncaq_net" {
  zone_id                 = var.zone_id
  ai_bots_protection      = "disabled"
  ai_training             = "disabled"
  ai_user                 = "disabled"
  aisearch                = "disabled"
  content_bots_protection = "disabled"
  crawler_protection      = "disabled"
  enable_js               = false
  fight_mode              = false
  is_robots_txt_managed   = false
}

# Forgejoにログインフォームがあるので、
# 漏洩済みの資格情報でのログイン試行を検出する。
# 検出だけでは何も起きないため、下のカスタムルールでチャレンジを出す。
resource "cloudflare_leaked_credential_check" "ncaq_net" {
  zone_id = var.zone_id
  enabled = true
}

resource "cloudflare_ruleset" "firewall_custom" {
  zone_id = var.zone_id
  name    = "firewall custom"
  kind    = "zone"
  phase   = "http_request_firewall_custom"

  rules = [
    {
      ref         = "leaked_password"
      description = "漏洩済みのパスワードでの認証にはチャレンジを出す"
      expression  = "(cf.waf.credential_check.password_leaked)"
      action      = "managed_challenge"
      enabled     = true
    },
  ]
}

resource "cloudflare_managed_transforms" "ncaq_net" {
  zone_id = var.zone_id
  managed_request_headers = [
    { id = "add_client_certificate_headers", enabled = false },
    { id = "add_visitor_location_headers", enabled = false },
    { id = "remove_visitor_ip_headers", enabled = false },
    { id = "add_waf_credential_check_status_header", enabled = false },
  ]
  managed_response_headers = [
    { id = "remove_x-powered-by_header", enabled = false },
    { id = "add_security_headers", enabled = false },
  ]
}
