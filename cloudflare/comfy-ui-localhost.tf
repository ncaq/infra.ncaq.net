# ローカルで動くComfyUIに、
# `https://comfy-ui.localhost.ncaq.net`でアクセスするための、
# ループバック向けAレコード。
# ローカルマシンが`localhost`などでListenしていて、
# クライアントは自分のマシンのループバックに接続する。
# ここに登録する目的は、
# Let's EncryptのDNS-01チャレンジ用のTXTレコードをCloudflareに置くために、
# 名前解決可能なドメインとして所有権を確立すること。
# プロキシは意味がないので必ず`false`。
resource "cloudflare_dns_record" "comfy-ui-localhost-v4" {
  zone_id = var.zone_id
  name    = "comfy-ui.localhost.ncaq.net"
  type    = "A"
  content = "127.0.0.1"
  proxied = false
  ttl     = 1
}

# 一応IPv6向けのループバックレコードも登録しておきます。
resource "cloudflare_dns_record" "comfy-ui-localhost-v6" {
  zone_id = var.zone_id
  name    = "comfy-ui.localhost.ncaq.net"
  type    = "AAAA"
  content = "::1"
  proxied = false
  ttl     = 1
}
