resource "tailscale_acl" "this" {
  depends_on = [
    tailscale_service.comfyui,
    tailscale_service.ollama,
  ]

  acl = jsonencode({
    tagOwners = merge({
      # サーバをautogroupから剥がすことで`tailscale ssh`アクセスを禁止します。
      # Tailscaleに接続できて、
      # SSH鍵を持っている。
      # という二段階のガードを設定するにあたって、
      # Tailscaleだけでssh出来てしまうと意味がないからです。
      # クライアントが一時的に立ち上げる場合パスワード認証よりはマシなので、
      # 全体的には禁止しません。
      "tag:server" = ["autogroup:admin", "tag:server"],
      # Terraformで使用するdotfiles-sops OAuthクライアントにはtag:serverが設定されているため、
      # そのクライアントからServiceホスト用タグを付与できるようにします。
      "tag:comfyui" = ["autogroup:admin", "tag:server"],
      },
      { for tag in local.ollama_tags : tag => ["autogroup:admin", "tag:server"] }
    ),
    grants = [
      # タグを付与すると端末はautogroup:memberから外れるため、
      # タグ付与前のautogroup:memberと同じIPアクセスを維持します。
      {
        src = ["autogroup:member"],
        dst = concat([
          "autogroup:member",
          "autogroup:internet",
          "tag:server",
          "tag:comfyui",
        ], local.ollama_tags),
        ip = ["*"],
      },
      {
        src = ["tag:server"],
        dst = concat([
          "autogroup:member",
          "tag:comfyui",
        ], local.ollama_tags),
        ip = ["*"],
      },
      {
        src = ["tag:comfyui"],
        dst = concat(
          ["autogroup:member", "autogroup:internet", "tag:server"],
          local.ollama_tags
        ),
        ip = ["*"],
      },
      # Ollamaタグを付与した端末にもタグ付与前と同等のIPアクセスを維持します。
      {
        src = local.ollama_tags,
        dst = concat([
          "autogroup:member",
          "autogroup:internet",
          "tag:server",
          "tag:comfyui",
        ], local.ollama_tags),
        ip = ["*"],
      },
      # tailnetのユーザー所有端末とServiceホスト自身から、
      # ComfyUIのHTTPS endpointだけへアクセスを許可します。
      {
        src = concat([
          "autogroup:member",
          "tag:server",
          "tag:comfyui",
        ], local.ollama_tags),
        dst = ["svc:comfyui"],
        ip  = ["tcp:443"],
      },
      # tailnet内の端末から各ホストのOllama HTTPS endpointへアクセスを許可します。
      {
        src = concat([
          "autogroup:member",
          "tag:server",
          "tag:comfyui",
        ], local.ollama_tags),
        dst = local.ollama_services,
        ip  = ["tcp:443"],
      },
    ],
    # 指定されたタグ付きのデバイスもexit nodeとしては自動承認します。
    autoApprovers = {
      exitNode = ["tag:server"],
      # 対応するホストタグを持つ端末からのService広告を自動承認します。
      services = merge(
        { "svc:comfyui" = ["tag:comfyui"] },
        { for host in local.ollama_hosts : "svc:ollama-${host}" => ["tag:ollama-${host}"] }
      )
    },
    # serverがfunnelを使えるようにします。
    nodeAttrs = [
      {
        target = ["tag:server"]
        attr   = ["funnel"]
      },
    ]
    ssh = [
      {
        action = "check",
        src    = ["autogroup:member"],
        dst    = ["autogroup:self"],
        users  = ["autogroup:nonroot"],
      }
    ],
  })
}
