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
  for_each  = local.device
  device_id = data.tailscale_device.this[each.key].id
}

resource "tailscale_device_tags" "seminar" {
  device_id  = data.tailscale_device.this["seminar"].id
  tags       = ["tag:server"]
  depends_on = [tailscale_acl.this]
}

resource "tailscale_device_subnet_routes" "seminar" {
  device_id = data.tailscale_device.this["seminar"].id
  routes = [
    "0.0.0.0/0",
    "::/0",
  ]
}
