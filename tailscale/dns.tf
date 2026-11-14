resource "tailscale_dns_configuration" "this" {
  # ホストにTailscaleのDNS経由で接続できます。
  magic_dns = true
  # システムのDNS設定を上書きします。
  override_local_dns = true
  # 以下のDNSサーバーを使用します。
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
