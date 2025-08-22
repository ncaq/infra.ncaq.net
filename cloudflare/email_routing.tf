# Email Routing宛先アドレス
resource "cloudflare_email_routing_address" "gmail" {
  account_id = var.account_id
  email      = "ncaq.net@gmail.com"
}

# 全メール転送ルール
resource "cloudflare_email_routing_catch_all" "catch_all" {
  zone_id = var.zone_id
  name    = "Catch all"
  enabled = true

  matchers = [
    {
      type = "all"
    }
  ]

  actions = [
    {
      type  = "forward"
      value = [cloudflare_email_routing_address.gmail.email]
    }
  ]
}
