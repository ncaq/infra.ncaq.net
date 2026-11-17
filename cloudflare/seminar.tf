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

locals {
  # seminarがCloudflare Tunnel経由で公開しているサービスのホスト名。
  # `<名前>.ncaq.net`がTunnelを向くCNAMEになる。
  seminar_tunnel_hostnames = toset([
    # cdn.ncaq.netはseminarからCloudflare Tunnel経由で配信しています。
    # Pagesには1ファイル25MiBの制限があり配信できないファイルがあるため移行しました。
    # 配信設定はdotfilesのnixos/host/seminar/cdn.nixにあります。
    "cdn",
    "forgejo",
    "garage",
    "mcp-nixos",
    "niks3-public",
  ])
}

resource "cloudflare_dns_record" "seminar_tunnel" {
  for_each = local.seminar_tunnel_hostnames

  zone_id = var.zone_id
  name    = "${each.key}.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

# ssh接続でcloneやpushを行うためのアクセスポイントです。
# Cloudflare Zero Trust Tunnelは、
# httpsでは一回での通信に転送量制限を厳しく設定していて、
# 無料版ではそれを解除できません。
# よってsshでも接続できるようにしています。
# Tailscale経由でのみアクセス可能です。
# CNAMEで`seminar.border-saurolophus.ts.net`を参照させたかったのですが、
# WindowsとAndroidが現状CNAMEチェーンを追跡しないため、
# IPアドレスを指定しています。
# TailscaleのIPアドレスは公開しても問題ないため`proxied = false`。
resource "cloudflare_dns_record" "forgejo_ssh_v4" {
  zone_id = var.zone_id
  name    = "ssh.forgejo.ncaq.net"
  type    = "A"
  content = var.seminar_tailscale_ipv4
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "forgejo_ssh_v6" {
  zone_id = var.zone_id
  name    = "ssh.forgejo.ncaq.net"
  type    = "AAAA"
  content = var.seminar_tailscale_ipv6
  proxied = false
  ttl     = 1
}
