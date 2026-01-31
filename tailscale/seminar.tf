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
