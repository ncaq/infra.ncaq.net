# cdn.ncaq.netはseminarからCloudflare Tunnel経由で配信しています。
# Pagesには1ファイル25MiBの制限があり配信できないファイルがあるため移行しました。
# 配信設定はdotfilesのnixos/host/seminar/cdn.nixにあります。
resource "cloudflare_dns_record" "cdn" {
  zone_id = var.zone_id
  name    = "cdn.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
