resource "cloudflare_dns_record" "cdn" {
  zone_id = var.zone_id
  name    = "cdn.ncaq.net"
  type    = "CNAME"
  content = "cdn-ncaq-net.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "root" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CNAME"
  content = "ncaq-net.pages.dev"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "www" {
  zone_id = var.zone_id
  name    = "www.ncaq.net"
  type    = "CNAME"
  content = "www-ncaq-net.pages.dev"
  proxied = true
  ttl     = 1
}

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
  ttl = 300
  priority = 1
}

resource "cloudflare_dns_record" "txt_atproto" {
  zone_id = var.zone_id
  name    = "_atproto.ncaq.net"
  type    = "TXT"
  content = "did=did:plc:2ivzjhpzepddchdol2xn2nba"
  comment = "bsky.app"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_discord" {
  zone_id = var.zone_id
  name    = "_discord.ncaq.net"
  type    = "TXT"
  content = "dh=08cb031d3313b647d5cb1de68a32bcbd39ea629d"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_dmarc" {
  zone_id = var.zone_id
  name    = "_dmarc.ncaq.net"
  type    = "TXT"
  content = "v=DMARC1;  p=quarantine; rua=mailto:9ebd3e36b8184ac595e59834e3c55330@dmarc-reports.cloudflare.net"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_openai" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "openai-domain-verification=dv-UOhZhkLVDPgiNIvpnIqd7WQa"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_spf" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "v=spf1 include:_spf.mx.cloudflare.net ~all"
  ttl     = 300
}

resource "cloudflare_dns_record" "txt_google_verification" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "TXT"
  content = "google-site-verification=F2w0ad_9TYxlSSYJnKjdCt8oco11oOfYHYMuCsvfLYw"
  ttl     = 300
}
