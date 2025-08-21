# DNSレコード - CNAME
resource "cloudflare_record" "cdn" {
  zone_id = var.zone_id
  name    = "cdn"
  type    = "CNAME"
  content = "cdn-ncaq-net.pages.dev"
  proxied = true
}

resource "cloudflare_record" "em8260" {
  zone_id = var.zone_id
  name    = "em8260"
  type    = "CNAME"
  content = "u37236823.wl074.sendgrid.net"
  proxied = false
}

resource "cloudflare_record" "root" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CNAME"
  content = "ncaq-net.pages.dev"
  proxied = true
}

resource "cloudflare_record" "s1_domainkey" {
  zone_id = var.zone_id
  name    = "s1._domainkey"
  type    = "CNAME"
  content = "s1.domainkey.u37236823.wl074.sendgrid.net"
  proxied = false
}

resource "cloudflare_record" "s2_domainkey" {
  zone_id = var.zone_id
  name    = "s2._domainkey"
  type    = "CNAME"
  content = "s2.domainkey.u37236823.wl074.sendgrid.net"
  proxied = false
}

resource "cloudflare_record" "tt_rss" {
  zone_id = var.zone_id
  name    = "tt-rss"
  type    = "CNAME"
  content = "plain.ncaq.net"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  type    = "CNAME"
  content = "www-ncaq-net.pages.dev"
  proxied = true
}

# DNSレコード - MX
resource "cloudflare_record" "mx_route1" {
  zone_id  = var.zone_id
  name     = "ncaq.net"
  type     = "MX"
  content  = "route1.mx.cloudflare.net"
  priority = 72
}

resource "cloudflare_record" "mx_route2" {
  zone_id  = var.zone_id
  name     = "ncaq.net"
  type     = "MX"
  content  = "route2.mx.cloudflare.net"
  priority = 47
}

resource "cloudflare_record" "mx_route3" {
  zone_id  = var.zone_id
  name     = "ncaq.net"
  type     = "MX"
  content  = "route3.mx.cloudflare.net"
  priority = 38
}

# DNSレコード - SRV
resource "cloudflare_record" "srv_imap" {
  zone_id = var.zone_id
  name    = "_imap._tls"
  type    = "SRV"
  data {
    priority = 1
    weight   = 1
    port     = 993
    target   = "imap.gmail.com"
  }
}

resource "cloudflare_record" "srv_smtp" {
  zone_id = var.zone_id
  name    = "_smtp._tls"
  type    = "SRV"
  data {
    priority = 1
    weight   = 1
    port     = 587
    target   = "smtp.sendgrid.net"
  }
}

# DNSレコード - TXT
resource "cloudflare_record" "txt_acme_challenge_cdn" {
  zone_id = var.zone_id
  name    = "_acme-challenge.cdn"
  type    = "TXT"
  content = "Y-MYbvxIBVIQ3UV-C3SMq2UXdIAd0V5rDvv0_l-e9L8"
}

resource "cloudflare_record" "txt_atproto" {
  zone_id = var.zone_id
  name    = "_atproto"
  type    = "TXT"
  content = "did=did:plc:2ivzjhpzepddchdol2xn2nba"
  comment = "bsky.app"
}

resource "cloudflare_record" "txt_dkim_cf2024" {
  zone_id = var.zone_id
  name    = "cf2024-1._domainkey"
  type    = "TXT"
  content = "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78km4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB"
}

resource "cloudflare_record" "txt_discord" {
  zone_id = var.zone_id
  name    = "_discord"
  type    = "TXT"
  content = "dh=08cb031d3313b647d5cb1de68a32bcbd39ea629d"
}

resource "cloudflare_record" "txt_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "v=DMARC1;  p=quarantine; rua=mailto:9ebd3e36b8184ac595e59834e3c55330@dmarc-reports.cloudflare.net"
}

resource "cloudflare_record" "txt_openai" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "openai-domain-verification=dv-UOhZhkLVDPgiNIvpnIqd7WQa"
}

resource "cloudflare_record" "txt_spf" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "v=spf1 include:_spf.mx.cloudflare.net ~all"
}

resource "cloudflare_record" "txt_google_verification" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "google-site-verification=F2w0ad_9TYxlSSYJnKjdCt8oco11oOfYHYMuCsvfLYw"
}
