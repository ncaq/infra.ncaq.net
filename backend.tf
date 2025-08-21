# Terraformの状態管理設定
# ローカル管理の例（デフォルト）
terraform {
  # backend "local" {
  #   path = "terraform.tfstate"
  # }

  # S3バックエンドの例（推奨）
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "cloudflare/terraform.tfstate"
  #   region = "ap-northeast-1"
  #   # encrypt = true
  #   # dynamodb_table = "terraform-state-lock"
  # }

  # Cloudflare R2バックエンドの例
  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "cloudflare/terraform.tfstate"
  #   region = "auto"
  #   endpoints = {
  #     s3 = "https://<account_id>.r2.cloudflarestorage.com"
  #   }
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  # }
}
