locals {
  # ncaq.netに証明書を発行して良いCA。
  # 検証を怠るCAが勝手に発行する事故を防ぐために明示する。
  #
  # 実際に発行しているのはCloudflare Universal SSLと、
  # seminarのlego(dotfilesのnixos/host/seminar/acme.nix)によるLet's Encryptの2経路。
  # Universal SSLはCAを選べずパートナーCAの間で切り替わるため、
  # Cloudflareが使う全CAを許可する必要がある。
  # Sectigoはバックアップ証明書にのみ使われる。
  # https://developers.cloudflare.com/ssl/reference/certificate-authorities/#caa-records
  #
  # Universal SSLは*.ncaq.netを含む証明書を発行するので、issuewildも同じCAに揃える。
  #
  # CAAを1つでも置くと、Cloudflareはダッシュボードに出ない形でこれらと同じCAAをエッジで自動的に足す。
  # 見えないレコードに頼らず、何を許可しているかをここで明示する。
  # https://developers.cloudflare.com/ssl/edge-certificates/caa-records/#caa-records-added-by-cloudflare
  caa_issuers = {
    letsencrypt = "letsencrypt.org"
    google      = "pki.goog; cansignhttpexchanges=yes"
    sslcom      = "ssl.com"
    sectigo     = "sectigo.com"
  }
  caa_issue_records = merge(
    { for name, value in local.caa_issuers : "issue_${name}" => { tag = "issue", value = value } },
    { for name, value in local.caa_issuers : "issuewild_${name}" => { tag = "issuewild", value = value } },
  )
}

resource "cloudflare_dns_record" "caa_issue" {
  for_each = local.caa_issue_records

  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CAA"
  data = {
    flags = 0
    tag   = each.value.tag
    value = each.value.value
  }
  ttl = 300
}

# CAAに違反する発行要求があった時にCAから通知を受け取る。
resource "cloudflare_dns_record" "caa_iodef" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CAA"
  data = {
    flags = 0
    tag   = "iodef"
    value = "mailto:ncaq@ncaq.net"
  }
  ttl = 300
}
