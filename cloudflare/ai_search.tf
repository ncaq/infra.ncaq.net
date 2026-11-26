# Search for Agentsのための設定。
# https://developers.cloudflare.com/ai-search/how-to/search-for-agents/
#
# ゾーンのQuick Actionsにあるトグル自体は、
# 公開APIにもTerraformプロバイダにも対応する項目が無いため、ダッシュボードで操作する。
# ここではトグルの裏側にあるAI Searchのリソースだけを管理する。

# Search for Agentsはdefaultのnamespaceを要求する。
resource "cloudflare_ai_search_namespace" "default" {
  account_id = var.account_id
  name       = "default"

  public_endpoint_params = {
    enabled                = true
    default_domain_enabled = true
    custom_domains         = ["search-for-agents.ncaq.net"]
    instances_allowed      = [cloudflare_ai_search_instance.www_ncaq_net.id]
    rate_limit = {
      requests  = 100
      period_ms = 60000
      technique = "sliding"
    }
  }
}

# ncaq.netの頂点にはリダイレクトとWKDぐらいしか置いていないので、
# 自動作成されるインスタンスではなく、www.ncaq.netを対象にしたインスタンスを使う。
resource "cloudflare_ai_search_instance" "www_ncaq_net" {
  account_id = var.account_id
  namespace  = "default"
  id         = "www-ncaq-net"

  type   = "web-crawler"
  source = "www.ncaq.net"
  source_params = {
    web_crawler = {
      parse_type = "sitemap"
      parse_options = {
        include_images        = true
        use_browser_rendering = false
        specific_sitemaps     = ["https://www.ncaq.net/sitemap.xml"]
      }
    }
  }
  sync_interval = 86400

  embedding_model = "@cf/qwen/qwen3-embedding-0.6b"
  chunk_size      = 1024
  chunk_overlap   = 10
  index_method = {
    vector  = true
    keyword = true
  }
  indexing_options = {
    keyword_tokenizer = "porter"
    use_ocr           = true
  }

  fusion_method = "rrf"
  retrieval_options = {
    keyword_match_mode = "and"
  }
  rewrite_query   = true
  reranking       = true
  score_threshold = 0.4
  max_num_results = 10

  cache           = true
  cache_threshold = "close_enough"
  cache_ttl       = 172800

  public_endpoint_params = {
    enabled                = false
    default_domain_enabled = true
    custom_domains         = []
    rate_limit = {
      requests  = 120
      period_ms = 60000
      technique = "fixed"
    }
    mcp = {
      disabled    = false
      description = "Finds exactly what you're looking for"
    }
  }
}

# AI Searchがnamespaceのカスタムドメイン用に自動で作ったレコード。
resource "cloudflare_dns_record" "search_for_agents" {
  zone_id = var.zone_id
  name    = "search-for-agents.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_ai_search_namespace.default.public_endpoint_id}.search.ai.cloudflare.com"
  proxied = true
  ttl     = 1
  comment = "Auto-created for AI Search custom domain"
}
