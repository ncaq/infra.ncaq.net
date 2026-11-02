locals {
  # ServiceがHTTPSに加えてHTTPも受け付けるようにします。
  # 80番はdotfilesの`lib/tailscale-serve.nix`のCaddyへ繋がり、
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
  # Serviceホストに付与するタグの集合です。
  # タグを付けると端末はautogroup:memberから外れるため、
  # grantのsrcやdstとtestsで、ユーザ端末とは別に列挙する必要があります。
  service_host_tags = concat([
    "tag:server",
    "tag:comfyui",
  ], local.ollama_tags)
  # Serviceホストのタグのうち、grantで自分自身のタグへの到達を許可していないものです。
  # `tag:server`と`tag:comfyui`のgrantはdstに自分のタグを含めていません。
  # Ollamaのタグはsrcとdstの両方に`local.ollama_tags`を使うため、自分自身へも到達できます。
  # testsで自分自身への到達を期待から外す時にこの集合を使います。
  tags_without_self_grant = ["tag:server", "tag:comfyui"]
  # tailnet内の全ての端末を表すsrcの集合です。
  # ユーザ所有の端末に加えて、Serviceホストの各タグを含めます。
  # Serviceや内部アドレスへのgrantは全てこの集合から許可するので、
  # タグを増やした時にgrantごとに書き漏らさないよう1箇所にまとめます。
  tailnet_all_sources = concat(["autogroup:member"], local.service_host_tags)
  # testsのsrcに使う集合です。
  # testsのsrcにはautogroupを書けないため、
  # autogroup:memberの代表としてユーザのメールアドレスを使います。
  tailnet_test_sources = concat([local.email], local.service_host_tags)
  # tailnetに定義している全てのServiceです。
  # testsでServiceが80と443以外を閉じていることを一括で確認するために使います。
  all_services = concat([
    tailscale_service.comfyui.name,
    tailscale_service.open_webui.name,
    tailscale_service.niks3_private.name,
  ], local.ollama_services)
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

# tailnet専用のNixバイナリキャッシュniks3-privateへ安定したMagicDNS名とTailVIPを割り当てます。
# 公開するのは常時起動のseminarだけなのでService名にホスト名は入れません。
resource "tailscale_service" "niks3_private" {
  name  = "svc:niks3-private"
  ports = local.service_ports
}
