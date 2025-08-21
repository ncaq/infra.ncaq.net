# 既存のCloudflareリソースをインポートするための定義
# インポート後は適切なファイルに移動してください

# DNSレコードの例
# resource "cloudflare_record" "example" {
#   zone_id = var.zone_id
#   name    = "example"
#   type    = "A"
#   value   = "192.0.2.1"
#   proxied = true
# }

# ページルールの例
# resource "cloudflare_page_rule" "example" {
#   zone_id  = var.zone_id
#   target   = "example.com/*"
#   priority = 1
#   actions {
#     ssl = "flexible"
#   }
# }

# ファイアウォールルールの例
# resource "cloudflare_ruleset" "zone_custom_firewall" {
#   zone_id = var.zone_id
#   name    = "Custom Firewall Rules"
#   kind    = "zone"
#   phase   = "http_request_firewall_custom"
# }
