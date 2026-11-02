locals {
  device = {
    bullet      = "bullet.border-saurolophus.ts.net"
    butterfly   = "butterfly.border-saurolophus.ts.net"
    creep       = "creep.border-saurolophus.ts.net"
    paint       = "paint.border-saurolophus.ts.net"
    seminar     = "seminar.border-saurolophus.ts.net"
    ssd0086     = "ssd0086.border-saurolophus.ts.net"
    ssd0086_wsl = "ssd0086-wsl.border-saurolophus.ts.net"
  }
}

data "tailscale_device" "this" {
  for_each = local.device
  name     = each.value
}

resource "tailscale_device_authorization" "this" {
  for_each   = local.device
  device_id  = data.tailscale_device.this[each.key].id
  authorized = true
}

# 全ての端末の鍵を意図的に無期限にしています。
#
# 鍵の有効期限が効くのは、ディスクが復号された状態で鍵ファイルだけを盗まれた場合に、
# 被害の期間を区切ることです。
# 持ち出す端末はディスクを暗号化しているため、端末ごと盗まれても鍵は読み出せません。
# 復号できる状態で盗まれたなら有効期限があっても意味がありません。
#
# 端末は数台しかないため、盗難や紛失に気付いた時点で`local.device`から外してapplyし、
# Terraformで失効させる方が期限切れを待つより早くて確実です。
# 有効期限で勝手にオフラインになると、Terraformの管理と実態が食い違う方が実害があります。
resource "tailscale_device_key" "this" {
  for_each            = local.device
  device_id           = data.tailscale_device.this[each.key].id
  key_expiry_disabled = true
}
