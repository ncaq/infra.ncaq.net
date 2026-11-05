# ゾーン全体で1つだけ持てるレート制限ルールセット。
# Freeプランではルール数1、期間10秒、ブロック継続10秒、特性はIPのみに制限される。
# https://developers.cloudflare.com/waf/rate-limiting-rules/#availability
# 別のホストにもレート制限を掛けたくなった時は、
# 新しいrulesetを作るのではなく、このrulesの中へルールを足す。
#
# mcp-nixos.ncaq.netは認証無しで公開している読み取り専用のMCPサーバで、
# 裏側はメモリ640MBのmicroVM1台なので、雑な大量リクエストで簡単に詰まる。
# MCPクライアントは1セッションでもinitializeとtools/listと複数のtool呼び出しを連続で送り、
# 同じNATの裏で複数のエージェントが並行して使うこともあるため、閾値は緩めにしてある。
# 正規の利用で10秒に100回を超えることはまず無い一方、floodはこれで十分に止まる。
resource "cloudflare_ruleset" "rate_limit" {
  zone_id     = var.zone_id
  name        = "rate limit"
  description = "Zone-level rate limiting rules"
  kind        = "zone"
  phase       = "http_ratelimit"
  rules = [
    {
      ref         = "mcp_nixos"
      description = "mcp-nixos.ncaq.net flood protection"
      expression  = "(http.host eq \"mcp-nixos.ncaq.net\")"
      action      = "block"
      enabled     = true
      ratelimit = {
        # Freeプランで指定可能な特性はこの組み合わせのみ。
        # cf.colo.idはデータセンター毎にカウンタを持つためのもので、expressionには使わない。
        characteristics     = ["cf.colo.id", "ip.src"]
        period              = 10
        requests_per_period = 100
        mitigation_timeout  = 10
      }
    }
  ]
}
