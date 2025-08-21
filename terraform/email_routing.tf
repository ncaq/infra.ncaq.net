# Email Routing宛先アドレス
resource "cloudflare_email_routing_address" "gmail" {
  account_id = var.account_id
  email      = "ncaq.net@gmail.com"
}

# 全メール転送ルール（キャッチオール）
resource "cloudflare_email_routing_rule" "catch_all" {
  zone_id = var.zone_id
  name    = ""
  enabled = true

  matcher {
    type = "all"
  }

  action {
    type  = "forward"
    value = [cloudflare_email_routing_address.gmail.email]
  }

  priority = 2147483647
}