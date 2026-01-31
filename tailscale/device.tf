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

resource "tailscale_device_key" "this" {
  for_each            = local.device
  device_id           = data.tailscale_device.this[each.key].id
  key_expiry_disabled = true # 個人使用なら無期限で良いと思うため
}
