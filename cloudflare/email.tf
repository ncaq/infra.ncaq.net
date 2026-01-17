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

# 認証
resource "cloudflare_dns_record" "txt_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.ncaq.net"
  type    = "TXT"
  content = "v=DMARC1;  p=quarantine; rua=mailto:9ebd3e36b8184ac595e59834e3c55330@dmarc-reports.cloudflare.net"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_spf" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  ttl     = 300
}

# クライアント向けヒント
resource "cloudflare_dns_record" "srv_imap" {
  zone_id = var.zone_id
  name    = "_imap._tls.ncaq.net"
  type    = "SRV"
  data = {
    priority = 1
    weight   = 1
    port     = 993
    target   = "imap.gmail.com"
  }
  ttl      = 300
  priority = 1
}
