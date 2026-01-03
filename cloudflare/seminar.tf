resource "cloudflare_zero_trust_tunnel_cloudflared" "seminar" {
  account_id    = var.account_id
  name          = "seminar"
  config_src    = "local"
  tunnel_secret = base64encode(random_password.seminar.result)
}

resource "random_password" "seminar" {
  length  = 63
  special = false
}

resource "cloudflare_dns_record" "seminar-ssh" {
  zone_id = var.zone_id
  name    = "seminar-ssh.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
