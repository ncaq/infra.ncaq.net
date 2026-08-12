locals {
  # ServiceがHTTPSに加えてHTTPも受け付けるようにします。
  # 80番はdotfilesの`nixos/tailscale-serve/http-redirect.nix`のCaddyへ繋がり、
  # HTTPSへリダイレクトを返すだけで中身は何も出しません。
  # 閉じたままだと`http://`で飛んできた時にTCP接続ごと拒否されて、
  # URL補完から辿り着けません。
  service_ports = ["tcp:80", "tcp:443"]
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
  ports = local.service_ports
}

# 各ホストのOllamaへ安定したMagicDNS名とTailVIPを割り当てます。
resource "tailscale_service" "ollama" {
  for_each = local.ollama_hosts

  name  = "svc:ollama-${each.key}"
  ports = local.service_ports
}

# Open WebUIへ安定したMagicDNS名とTailVIPを割り当てます。
# 推論はOpen WebUI側でbulletのOllamaへ優先的に振り分けるため、
# UIを公開するホストが変わってもここは1つで足ります。
resource "tailscale_service" "open_webui" {
  name  = "svc:open-webui"
  ports = local.service_ports
}
