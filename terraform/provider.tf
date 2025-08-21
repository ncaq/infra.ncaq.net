provider "cloudflare" {
  # api_tokenは環境変数CLOUDFLARE_API_TOKENから読み込み
  # または以下のように直接指定も可能（推奨しない）
  # api_token = var.cloudflare_api_token
}
