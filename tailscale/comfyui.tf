# bulletをComfyUI Service専用のホストとして識別します。
resource "tailscale_device_tags" "bullet" {
  device_id  = data.tailscale_device.this["bullet"].id
  tags       = ["tag:comfyui"]
  depends_on = [tailscale_acl.this]
}

# ComfyUIへ割り当てる安定したMagicDNS名とTailVIPを作成します。
resource "tailscale_service" "comfyui" {
  name  = "svc:comfyui"
  ports = ["tcp:443"]
}
