resource "tailscale_dns_configuration" "this" {
  # ホストにTailscaleのDNS経由で接続できます。
  magic_dns = true
  # システムのDNS設定は上書きしません。
  # 上書きするとsystemd-resolvedが全ての問い合わせをTailscaleのリゾルバへ流し、
  # そのリンクではDNSSECの検証が無効になるので、
  # 各端末が自分の設定で検証できるようにtailnetの名前だけをTailscaleに任せます。
  # NixOSのホストはdotfilesの設定でDNS over TLSとDNSSECの検証を使い、
  # AndroidはプライベートDNSを端末ごとに設定します。
  override_local_dns = false
  # 上書きしないので、以下のDNSサーバーは端末が自分のDNS設定を持たない時の予備です。
  # CloudflareとGoogleを混在させ、IPv6のサーバーを先に並べます。
  # dotfilesの`lib/public-dns.nix`と同じ方針で、同じ順に揃えています。
  # IPv6
  # Cloudflare Public DNS
  nameservers {
    address = "2606:4700:4700::1111"
  }
  nameservers {
    address = "2606:4700:4700::1001"
  }
  # Google Public DNS
  nameservers {
    address = "2001:4860:4860::8888"
  }
  nameservers {
    address = "2001:4860:4860::8844"
  }
  # IPv4
  # Cloudflare Public DNS
  nameservers {
    address = "1.1.1.1"
  }
  nameservers {
    address = "1.0.0.1"
  }
  # Google Public DNS
  nameservers {
    address = "8.8.8.8"
  }
  nameservers {
    address = "8.8.4.4"
  }
}
