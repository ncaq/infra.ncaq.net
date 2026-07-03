resource "cloudflare_dns_record" "mcp-nixos" {
  zone_id = var.zone_id
  name    = "mcp-nixos.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
