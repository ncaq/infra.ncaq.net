resource "tailscale_acl" "this" {
  depends_on = [
    tailscale_service.comfyui,
    tailscale_service.ollama,
  ]

  acl = jsonencode({
    tagOwners = {
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
      # Ollama Serviceはホストを明示的に選べるようにホスト固有タグで広告を制限します。
      "tag:ollama-bullet"  = ["autogroup:admin", "tag:server"],
      "tag:ollama-creep"   = ["autogroup:admin", "tag:server"],
      "tag:ollama-seminar" = ["autogroup:admin", "tag:server"],
    },
    grants = [
      # タグを付与すると端末はautogroup:memberから外れるため、
      # タグ付与前のautogroup:memberと同じIPアクセスを維持します。
      {
        src = ["autogroup:member"],
        dst = [
          "autogroup:member",
          "autogroup:internet",
          "tag:server",
          "tag:comfyui",
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        ip = ["*"],
      },
      {
        src = ["tag:server"],
        dst = [
          "autogroup:member",
          "tag:comfyui",
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        ip = ["*"],
      },
      {
        src = ["tag:comfyui"],
        dst = ["autogroup:member", "autogroup:internet", "tag:server"],
        ip  = ["*"],
      },
      # Ollamaタグを付与した端末にもタグ付与前と同等のIPアクセスを維持します。
      {
        src = [
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        dst = [
          "autogroup:member",
          "autogroup:internet",
          "tag:server",
          "tag:comfyui",
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        ip = ["*"],
      },
      # tailnetのユーザー所有端末とServiceホスト自身から、
      # ComfyUIのHTTPS endpointだけへアクセスを許可します。
      {
        src = [
          "autogroup:member",
          "tag:server",
          "tag:comfyui",
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        dst = ["svc:comfyui"],
        ip  = ["tcp:443"],
      },
      # tailnet内の端末から各ホストのOllama HTTPS endpointへアクセスを許可します。
      {
        src = [
          "autogroup:member",
          "tag:server",
          "tag:comfyui",
          "tag:ollama-bullet",
          "tag:ollama-creep",
          "tag:ollama-seminar",
        ],
        dst = [
          "svc:ollama-bullet",
          "svc:ollama-creep",
          "svc:ollama-seminar",
        ],
        ip = ["tcp:443"],
      },
    ],
    # 指定されたタグ付きのデバイスもexit nodeとしては自動承認します。
    autoApprovers = {
      exitNode = ["tag:server"],
      # 対応するホストタグを持つ端末からのService広告を自動承認します。
      services = {
        "svc:comfyui"        = ["tag:comfyui"]
        "svc:ollama-bullet"  = ["tag:ollama-bullet"]
        "svc:ollama-creep"   = ["tag:ollama-creep"]
        "svc:ollama-seminar" = ["tag:ollama-seminar"]
      }
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
