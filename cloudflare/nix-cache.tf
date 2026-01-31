# Tailnet内部からのみアクセス可能なatticバイナリキャッシュ。
# Tailscale IPは公開しても問題ないため`proxied = false`。
resource "cloudflare_dns_record" "cache_nix_a" {
  zone_id = var.zone_id
  name    = "cache.nix.ncaq.net"
  type    = "A"
  content = var.seminar_tailscale_ipv4
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "cache_nix_aaaa" {
  zone_id = var.zone_id
  name    = "cache.nix.ncaq.net"
  type    = "AAAA"
  content = var.seminar_tailscale_ipv6
  proxied = false
  ttl     = 1
}
