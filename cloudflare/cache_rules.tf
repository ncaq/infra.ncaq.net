# cdn.ncaq.netは静的ファイルの配信専用なので、
# 拡張子に関わらず全てのレスポンスをキャッシュ対象にする。
# TTLはゾーン設定の`edge_cache_ttl`と`browser_cache_ttl`に従う。
resource "cloudflare_ruleset" "cache_settings" {
  zone_id = var.zone_id
  name    = "cache settings"
  kind    = "zone"
  phase   = "http_request_cache_settings"

  rules = [
    {
      ref         = "cdn_cache_everything"
      description = "cdn.ncaq.netは全てキャッシュする"
      expression  = "(http.host eq \"cdn.ncaq.net\")"
      action      = "set_cache_settings"
      action_parameters = {
        cache = true
      }
      enabled = true
    },
  ]
}
