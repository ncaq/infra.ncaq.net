# CAAなどのレコードをDNSの経路上で改ざんされないように署名する。
# CAはCAAの検証時にDNSSECを検証するので、
# 署名が無いとCAAを偽装されて許可していないCAに発行される余地が残る。
#
# レジストラ側のDSレコードはTerraformの管理外。
# ダッシュボードの操作などで無効化されてしまったことに気づけるよう明示する。
resource "cloudflare_zone_dnssec" "ncaq_net" {
  zone_id = var.zone_id
  status  = "active"
}
