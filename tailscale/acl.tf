resource "tailscale_acl" "this" {
  acl = jsonencode({
    tagOwners = {
      # サーバをautogroupから剥がすことで`tailscale ssh`アクセスを禁止します。
      # Tailscaleに接続できて、
      # SSH鍵を持っている。
      # という二段階のガードを設定するにあたって、
      # Tailscaleだけでssh出来てしまうと意味がないからです。
      # クライアントが一時的に立ち上げる場合パスワード認証よりはマシなので、
      # 全体的には禁止しません。
      "tag:server" = ["tag:server", "autogroup:admin"],
    },
    grants = [
      {
        src = ["autogroup:member"],
        dst = ["autogroup:member"],
        ip  = ["*"],
      },
      {
        src = ["autogroup:member"],
        dst = ["tag:server"],
        ip  = ["*"],
      },
      {
        src = ["tag:server"],
        dst = ["autogroup:member"],
        ip  = ["*"],
      },
      {
        src = ["autogroup:member"],
        dst = ["autogroup:internet"],
        ip  = ["*"],
      },
    ],
    # 指定されたタグ付きのデバイスもexit nodeとしては自動承認します。
    autoApprovers = {
      exitNode = ["tag:server"],
    },
    ssh = [
      {
        action = "check",
        src    = ["autogroup:member"],
        dst    = ["autogroup:self"],
        users  = ["autogroup:nonroot"],
      },
    ],
  })
}
