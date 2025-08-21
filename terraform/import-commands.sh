#!/usr/bin/env bash
# Cloudflareの既存リソースをインポートするためのスクリプト
# 使用前に必要な環境変数を設定してください:
# - CLOUDFLARE_API_TOKEN
# - TF_VAR_zone_id
# - TF_VAR_account_id

set -euo pipefail

# 初期化
echo "Terraformを初期化しています..."
tofu init

# DNSレコードのインポート例
# tofu import cloudflare_record.example <zone_id>/<record_id>
# 例: tofu import cloudflare_record.www 1234567890abcdef/9876543210fedcba

# ページルールのインポート例
# tofu import cloudflare_page_rule.example <zone_id>/<page_rule_id>

# ファイアウォールルールのインポート例
# tofu import cloudflare_ruleset.zone_custom_firewall <zone_id>/<ruleset_id>

# WAFルールのインポート例
# tofu import cloudflare_ruleset.zone_waf <zone_id>/<ruleset_id>

# SSL/TLS設定のインポート例
# tofu import cloudflare_zone_settings_override.example <zone_id>

echo "インポートコマンドの例を確認してください。"
echo "実際のリソースIDはCloudflare APIまたはWebコンソールから取得してください。"
