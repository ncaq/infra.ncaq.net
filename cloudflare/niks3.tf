resource "cloudflare_dns_record" "niks3-public" {
  zone_id = var.zone_id
  name    = "niks3-public.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
