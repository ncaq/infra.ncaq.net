# ゾーンそのもの。
# 削除するとDNSを含む全ての設定が失われるので、Terraformからの削除を禁止する。
resource "cloudflare_zone" "ncaq_net" {
  account = {
    id = var.account_id
  }
  name = "ncaq.net"
  type = "full"

  lifecycle {
    prevent_destroy = true

    # 他のリソースはvar.zone_idを参照するので、取り違えると別のゾーンに適用されてしまう。
    postcondition {
      condition     = self.id == var.zone_id
      error_message = "var.zone_idがncaq.netのゾーンIDと一致しません。"
    }
  }
}

resource "cloudflare_url_normalization_settings" "ncaq_net" {
  zone_id = var.zone_id
  scope   = "incoming"
  type    = "cloudflare"
}

resource "cloudflare_tiered_cache" "ncaq_net" {
  zone_id = var.zone_id
  value   = "on"
}
