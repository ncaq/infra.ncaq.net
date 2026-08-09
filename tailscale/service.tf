locals {
  ollama_hosts = toset([
    "bullet",
    "seminar",
  ])
  ollama_tags         = [for host in local.ollama_hosts : "tag:ollama-${host}"]
  ollama_services     = [for host in local.ollama_hosts : "svc:ollama-${host}"]
  open_webui_services = [for host in local.ollama_hosts : "svc:open-webui-${host}"]
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

# 各ホストのOpen WebUIへ安定したMagicDNS名とTailVIPを割り当てます。
resource "tailscale_service" "open_webui" {
  for_each = local.ollama_hosts

  name  = "svc:open-webui-${each.key}"
  ports = ["tcp:443"]
}
