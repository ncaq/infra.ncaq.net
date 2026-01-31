# Tailnet内部からのみアクセス可能なmcp-nixos HTTPプロキシ。
# Tailscale IPは公開しても問題ないため`proxied = false`。
resource "cloudflare_dns_record" "mcp_proxy_v4" {
  zone_id = var.zone_id
  name    = "mcp-proxy.ncaq.net"
  type    = "A"
  content = var.seminar_tailscale_ipv4
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mcp_proxy_v6" {
  zone_id = var.zone_id
  name    = "mcp-proxy.ncaq.net"
  type    = "AAAA"
  content = var.seminar_tailscale_ipv6
  proxied = false
  ttl     = 1
}
