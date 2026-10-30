# ncaq.netの証明書がCAから発行されて公開CTログに載った時にメールで通知を受け取る。
# CAAとDNSSECは発行の抑止、CT監視は抑止をすり抜けた発行の検知を担う。
#
# Cloudflare自身が発行する証明書(Universal SSLの更新やバックアップ証明書)は、
# Cloudflare側で自動的にフィルタされるので、通知が来たら基本的に全て確認対象。
# ただしseminarのlegoによるLet's Encryptの発行は通知される。
# https://developers.cloudflare.com/ssl/edge-certificates/additional-options/certificate-transparency-monitoring/
#
# 既定ではオフなので、ダッシュボードの操作で無効化されたことに気づけるよう明示する。
resource "cloudflare_ct_alerting" "ncaq_net" {
  zone_id = var.zone_id
  enabled = true
  emails  = ["ncaq@ncaq.net"]
}
