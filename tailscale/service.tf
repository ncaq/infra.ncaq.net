locals {
  ollama_hosts = toset([
    "bullet",
    "seminar",
  ])
  ollama_tags     = [for host in local.ollama_hosts : "tag:ollama-${host}"]
  ollama_services = [for host in local.ollama_hosts : "svc:ollama-${host}"]
  # Open WebUIはチャット履歴を1箇所へまとめるため常時起動のseminarだけで動かします。
  open_webui_host = "seminar"
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

# Open WebUIへ安定したMagicDNS名とTailVIPを割り当てます。
# 推論はOpen WebUI側でbulletのOllamaへ優先的に振り分けるため、
# UIを公開するホストが変わってもここは1つで足ります。
resource "tailscale_service" "open_webui" {
  name  = "svc:open-webui"
  ports = ["tcp:443"]
}
