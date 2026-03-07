resource "cloudflare_dns_record" "garage" {
  zone_id = var.zone_id
  name    = "garage.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
