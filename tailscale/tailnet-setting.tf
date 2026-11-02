resource "tailscale_tailnet_settings" "this" {
  acls_external_link         = "https://github.com/ncaq/infra.ncaq.net"
  acls_externally_managed_on = true
  # 新しい端末はログインしただけではtailnetに参加できず、承認が必要になります。
  # 承認は`device.tf`の`tailscale_device_authorization`で行います。
  # アカウントが乗っ取られた時に、ログインだけで端末が静かに増えるのを防ぎ、
  # 管理画面かTerraformでの明示的な承認という手順を1つ挟みます。
  # 既存の端末は全て承認済みなので、有効にしても影響を受けません。
  #
  # この承認はownerアカウントとOAuthクライアントのシークレットが守られていることを前提にした防御です。
  # 管理画面からは事前承認付きのauth keyを発行でき、それで参加した端末は承認を経ません。
  # OAuthクライアントは`devices:core`を持つので、シークレットが漏れれば任意の端末を承認できます。
  # 事前承認付きのauth keyは発行しない運用にして、端末の追加は対話ログインと`device.tf`に限ります。
  # OAuthクライアントには`auth_keys`スコープを与えていないので、Terraform経由ではauth keyを作れません。
  devices_approval_on     = true
  devices_auto_updates_on = true
  # 端末の鍵の既定の有効期限です。
  # 既存の端末は`device.tf`で個別に無期限にしているため、
  # これが効くのは新しい端末が参加してから`device.tf`に追加されるまでの間だけです。
  devices_key_duration_days                   = 180
  https_enabled                               = true
  users_approval_on                           = true
  users_role_allowed_to_join_external_tailnet = "admin"
}
