locals {
  ollama_hosts = toset([
    "bullet",
    "creep",
    "seminar",
  ])
}

# ComfyUIへ安定したMagicDNS名とTailVIPを割り当てます。
resource "tailscale_service" "comfyui" {
  name  = "svc:comfyui"
  ports = ["tcp:443"]
}

# 各ホストのOllamaへ安定したMagicDNS名とTailVIPを割り当てます。
resource "tailscale_service" "ollama" {
  for_each = local.ollama_hosts

  name  = "svc:ollama-${each.key}"
  ports = ["tcp:443"]
}
