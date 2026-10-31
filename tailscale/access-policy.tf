resource "tailscale_acl" "this" {
  depends_on = [
    tailscale_service.comfyui,
    tailscale_service.ollama,
    tailscale_service.open_webui,
    tailscale_service.niks3_private,
  ]

  acl = jsonencode({
    tagOwners = merge({
      # Terraformで使用するdotfiles-sops OAuthクライアントにはtag:serverが設定されているため、
      # そのクライアントからServiceホスト用タグを付与できるようにします。
      "tag:server"  = ["autogroup:admin", "tag:server"],
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
      # ComfyUIのendpointだけへアクセスを許可します。
      # 許可するポートはServiceが公開するポートに揃えます。
      # HTTPの80番はHTTPSへリダイレクトを返すだけです。
      {
        src = local.tailnet_all_sources,
        dst = ["svc:comfyui"],
        ip  = local.service_ports,
      },
      # tailnet内の端末からOpen WebUIのendpointへアクセスを許可します。
      {
        src = local.tailnet_all_sources,
        dst = [tailscale_service.open_webui.name],
        ip  = local.service_ports,
      },
      # tailnet内の端末から各ホストのOllama endpointへアクセスを許可します。
      {
        src = local.tailnet_all_sources,
        dst = local.ollama_services,
        ip  = local.service_ports,
      },
      # tailnet内の端末からniks3-privateのバイナリキャッシュへアクセスを許可します。
      # 各ホストのnix-daemonがsubstituterとして読み、
      # niks3-auto-uploadが書き込みに使うため、全ての種類のホストから到達できる必要があります。
      {
        src = local.tailnet_all_sources,
        dst = [tailscale_service.niks3_private.name],
        ip  = local.service_ports,
      },
      # seminarをexit nodeにしている端末から、
      # seminar上のCaddyがniks3-publicとgarageを受けている内部アドレスへの接続を許可します。
      #
      # exit nodeを使う端末のDNSクエリはseminarのtailscaledが代理で解決し、
      # その答えにはseminarの`/etc/hosts`の内容が混ざります。
      # seminarは`niks3-public.ncaq.net`と`garage.ncaq.net`をホスト内で完結させるため、
      # `/etc/hosts`でコンテナのvethのホスト側アドレスへ向けているので、
      # exit node経由の端末にもその内部アドレスが返ります。
      # `autogroup:internet`にはプライベートアドレスが含まれないため、
      # 別途許可しないとseminarのパケットフィルタで捨てられてniks3-publicやgarageに繋がりません。
      #
      # 許可だけでは足りず、seminarがこのアドレスをサブネットルートとして広告する必要があります。
      # 広告はdotfilesの`nixos/host/seminar/tailscale-exit-node.nix`で、承認は`subnet-route.tf`です。
      # アドレスは承認と同じ`local.seminar_caddy_internal_routes`から取ります。
      {
        src = local.tailnet_all_sources,
        dst = values(local.seminar_caddy_internal_routes),
        ip  = ["tcp:443"],
      },
    ],
    # ポリシーを保存する時にTailscale側で評価されるテストです。
    # 失敗すると保存が拒否されて`terraform apply`も失敗するので、
    # grantのリグレッションをapplyの時点で検出できます。
    #
    # seminarのCaddyの内部アドレスは443だけ開いているべきで、
    # それ以外のポートは閉じているべきです。
    # srcの集合やipを後から変えた時に、
    # 意図しない開放や閉塞を検出するために両方を固定します。
    # srcにはautogroupを書けないので、
    # 集合に含まれる代表としてServiceホストのタグを使います。
    # 宛先にCIDRは書けないため、`cidrhost`でアドレスだけを取り出します。
    tests = [
      for src in ["tag:server", "tag:ollama-bullet"] : {
        src    = src
        proto  = "tcp"
        accept = [for route in values(local.seminar_caddy_internal_routes) : "${cidrhost(route, 0)}:443"]
        deny = flatten([
          for route in values(local.seminar_caddy_internal_routes) : [
            "${cidrhost(route, 0)}:22",
            "${cidrhost(route, 0)}:80",
          ]
        ])
      }
    ],
    # 指定されたタグ付きのデバイスもexit nodeとしては自動承認します。
    autoApprovers = {
      exitNode = ["tag:server"],
      # 対応するホストタグを持つ端末からのService広告を自動承認します。
      services = merge(
        { "svc:comfyui" = ["tag:comfyui"] },
        { for host in local.ollama_hosts : "svc:ollama-${host}" => ["tag:ollama-${host}"] },
        { (tailscale_service.open_webui.name) = ["tag:ollama-${local.open_webui_host}"] },
        # niks3-privateを公開するseminarはtag:serverを持ちます。
        { (tailscale_service.niks3_private.name) = ["tag:server"] }
      )
    },
  })
}
