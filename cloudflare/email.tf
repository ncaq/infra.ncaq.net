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

resource "cloudflare_dns_record" "txt_dkim" {
  zone_id = var.zone_id
  name    = "resend._domainkey"
  type    = "TXT"
  content = "p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDhvirIaSsC/w599eQYBCubrI9d9HoZoc5BlVZ2zlDqUk8QNy49OMZPxLvtA7D9P1e3Mz2m1/un9VYd0z3CG0CPmnrwcwccYNOM9NFB9eKTHxLsvdiRAwhGEp0XQ6bZUmu1VhwVpDqO7cmQ4m/6nS2retFjPQ74IKJ4R1OHOSbfEQIDAQAB"
  ttl     = 1
}

resource "cloudflare_dns_record" "mx_spf" {
  zone_id  = var.zone_id
  name     = "send"
  type     = "MX"
  content  = "feedback-smtp.ap-northeast-1.amazonses.com"
  ttl      = 1
  priority = 10
}

resource "cloudflare_dns_record" "txt_spf_root" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "v=spf1 include:_spf.mx.cloudflare.net include:amazonses.com ~all"
  ttl     = 1
}

resource "cloudflare_dns_record" "txt_spf_send" {
  zone_id = var.zone_id
  name    = "send"
  type    = "TXT"
  content = "v=spf1 include:amazonses.com ~all"
  ttl     = 1
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

resource "cloudflare_dns_record" "srv_smtp" {
  zone_id = var.zone_id
  name    = "_submission._tcp.ncaq.net"
  type    = "SRV"
  data = {
    priority = 1
    weight   = 1
    port     = 465
    target   = "smtp.resend.com"
  }
  ttl      = 300
  priority = 1
}
