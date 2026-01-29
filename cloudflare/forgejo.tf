resource "cloudflare_dns_record" "forgejo" {
  zone_id = var.zone_id
  name    = "forgejo.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

# ssh接続でcloneやpushを行うためのアクセスポイントです。
# 無料版のCloudflare Zero Trust Tunnelのhttpsでの一回での通信では転送量制限が厳しいのでsshで接続できるようにしています。
# Tailscale経由でのみアクセス可能です。
# CNAMEでseminar.border-saurolophus.ts.netを参照したかったのですが、
# Tailscale MagicDNSがCNAMEチェーンを追跡しないため、
# ひとまずAレコードで直接指定しています。
resource "cloudflare_dns_record" "forgejo-ssh" {
  zone_id = var.zone_id
  name    = "ssh.forgejo.ncaq.net"
  type    = "A"
  content = "100.82.4.93"
  proxied = false # sshなのでfalse。TailscaleのIPアドレスは公開しても問題ない。
  ttl     = 1
}
