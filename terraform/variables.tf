variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  # terraform.tfvarsまたは環境変数TF_VAR_zone_idで設定
}

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
  # terraform.tfvarsまたは環境変数TF_VAR_account_idで設定
}
