# Search for Agentsのための設定。
# https://developers.cloudflare.com/ai-search/how-to/search-for-agents/
#
# 機能自体のオンオフは`zone_settings.tf`の`search_for_agents`で管理する。
# オンにすると`search-for-agents-<ZONE_ID>`というインスタンスが自動作成され、
# ゾーンの各ホストの`/.well-known/search`はそのインスタンスが受ける。

# Search for Agentsはdefaultのnamespaceを要求する。
# namespace単位の公開エンドポイントは使わないので無効にしておく。
resource "cloudflare_ai_search_namespace" "default" {
  account_id = var.account_id
  name       = "default"

  public_endpoint_params = {
    enabled                = false
    default_domain_enabled = true
    custom_domains         = []
    instances_allowed      = []
    rate_limit = {
      requests  = 100
      period_ms = 60000
      technique = "sliding"
    }
  }
}

# Search for Agentsをオンにした時に自動作成されたインスタンス。
# データソースはncaq.netだが、リンクを辿ってwww.ncaq.netのページをクロールする。
#
# ゾーンとの紐付けはAPI上の`metadata.search_for_agents`に入っている。
# プロバイダの`metadata`にはこの項目が無いので、ここには書けない。
#
# このリソースに変更をapplyすると、空の`metadata`が送られて紐付けが消える。
# 消えると`/.well-known/search`が503の`Search is being configured`を返すようになる。
# その時はAPIでインスタンスの現在の設定を取得し、以下を足してPUTで書き戻す。
#
#   "metadata": {
#     "search_for_agents": {
#       "zone_id": "<ZONE_ID>",
#       "zone_name": "ncaq.net",
#       "hostname": "ncaq.net"
#     }
#   }
#
# PATCHはnamespaceの移動専用なので使えない。
# 書き戻した後は、以下でインスタンスが引けることを確かめる。
# GET /accounts/<ACCOUNT_ID>/ai-search/instances?hostname=ncaq.net
resource "cloudflare_ai_search_instance" "search_for_agents" {
  account_id = var.account_id
  namespace  = cloudflare_ai_search_namespace.default.name
  id         = "search-for-agents-${var.zone_id}"

  type   = "web-crawler"
  source = "https://ncaq.net"
  source_params = {
    web_crawler = {
      parse_type = "discover"
      parse_options = {
        include_images        = true
        use_browser_rendering = false
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
  rewrite_query   = false
  reranking       = true
  score_threshold = 0.4
  max_num_results = 10

  cache           = true
  cache_threshold = "close_enough"
  cache_ttl       = 172800

  # 省略するとnullが送られて、APIに`expected object, received null`で拒否される。
  # 空で送ることになるので、上に書いた通り紐付けが消える。
  metadata = {}
}
