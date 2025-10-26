resource "cloudflare_dns_record" "forgejo" {
  zone_id = var.zone_id
  name    = "forgejo.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

# ssh接続でcloneやpushを行うためのアクセスポイントです。
# 無料版のCloudflare Zero Trust Tunnelのhttpsでの一回での通信では転送量制限が厳しいのでsshに逃げられるようにしています。
# 無料版のCloudflare Zero Trust Tunnelの制約上`ssh.forgejo.ncaq.net`とするとTLSの解決ができないため、
# `forgejo-ssh.ncaq.net`で妥協しています。
resource "cloudflare_dns_record" "forgejo-ssh" {
  zone_id = var.zone_id
  name    = "forgejo-ssh.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}
