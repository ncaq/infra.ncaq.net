# 送信専用ドメイン。
# 検証用のDNSレコードは`cloudflare/email.tf`で管理している。
# `tls`と`custom_return_path`はResendのAPIが値を返さず、
# ドリフトを検知できないので書かない。
# Resend Forgeはダッシュボードで有効化している。
# APIとプロバイダにForgeの設定項目が無いので、ここには書けない。
# Forge用のCNAMEは`cloudflare/email.tf`で管理している。
resource "resend_domain" "ncaq_net" {
  name           = "ncaq.net"
  region         = "ap-northeast-1"
  open_tracking  = false
  click_tracking = false

  capabilities = {
    sending   = "enabled"
    receiving = "disabled"
  }
}
