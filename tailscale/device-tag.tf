resource "tailscale_device_tags" "bullet" {
  device_id  = data.tailscale_device.this["bullet"].id
  tags       = ["tag:comfyui", "tag:ollama-bullet"]
  depends_on = [tailscale_acl.this]
}

resource "tailscale_device_tags" "seminar" {
  device_id  = data.tailscale_device.this["seminar"].id
  tags       = ["tag:server", "tag:ollama-seminar"]
  depends_on = [tailscale_acl.this]
}
