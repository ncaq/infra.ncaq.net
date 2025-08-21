variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  # 環境変数`TF_VAR_zone_id`で設定
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
  # 環境変数`TF_VAR_account_id`で設定
}
