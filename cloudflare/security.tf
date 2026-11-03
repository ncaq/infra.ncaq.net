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

resource "cloudflare_leaked_credential_check" "ncaq_net" {
  zone_id = var.zone_id
  enabled = false
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
