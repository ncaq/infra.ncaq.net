resource "cloudflare_record" "cdn" {
  zone_id = var.zone_id
  name    = "cdn"
  type    = "CNAME"
  content = "cdn-ncaq-net.pages.dev"
  proxied = true
}

resource "cloudflare_record" "root" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CNAME"
  content = "ncaq-net.pages.dev"
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  type    = "CNAME"
  content = "www-ncaq-net.pages.dev"
  proxied = true
}

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

resource "cloudflare_record" "txt_atproto" {
  zone_id = var.zone_id
  name    = "_atproto"
  type    = "TXT"
  content = "did=did:plc:2ivzjhpzepddchdol2xn2nba"
  comment = "bsky.app"
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
