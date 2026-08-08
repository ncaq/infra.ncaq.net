resource "tailscale_device_subnet_routes" "seminar" {
  device_id = data.tailscale_device.this["seminar"].id
  routes = [
    "0.0.0.0/0",
    "::/0",
  ]
}
