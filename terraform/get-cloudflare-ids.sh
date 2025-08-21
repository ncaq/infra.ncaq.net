#!/usr/bin/env bash
# CloudflareのリソースIDを取得するスクリプト
# 使用前にCLOUDFLARE_API_TOKENを設定してください

set -euo pipefail

# 環境変数のチェック
if [[ -z ${CLOUDFLARE_API_TOKEN:-} ]]; then
  echo "エラー: CLOUDFLARE_API_TOKEN環境変数を設定してください" >&2
  exit 1
fi

API_BASE="https://api.cloudflare.com/client/v4"
AUTH_HEADER="Authorization: Bearer ${CLOUDFLARE_API_TOKEN}"

# ゾーン一覧の取得
echo "=== ゾーン一覧 ==="
curl -s -X GET "${API_BASE}/zones" \
  -H "${AUTH_HEADER}" \
  -H "Content-Type: application/json" |
  jq -r '.result[] | "Zone: \(.name) - ID: \(.id)"'

# 特定のゾーンIDを指定してDNSレコードを取得する場合
if [[ -n ${ZONE_ID:-} ]]; then
  echo ""
  echo "=== DNSレコード (Zone ID: ${ZONE_ID}) ==="
  curl -s -X GET "${API_BASE}/zones/${ZONE_ID}/dns_records" \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" |
    jq -r '.result[] | "Type: \(.type) - Name: \(.name) - ID: \(.id) - Content: \(.content)"'

  echo ""
  echo "=== ページルール ==="
  curl -s -X GET "${API_BASE}/zones/${ZONE_ID}/pagerules" \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" |
    jq -r '.result[] | "Target: \(.targets[0].constraint.value) - ID: \(.id)"'

  echo ""
  echo "=== ファイアウォールルール ==="
  curl -s -X GET "${API_BASE}/zones/${ZONE_ID}/firewall/rules" \
    -H "${AUTH_HEADER}" \
    -H "Content-Type: application/json" |
    jq -r '.result[] | "Description: \(.description // "No description") - ID: \(.id)"'
fi

echo ""
echo "特定のゾーンの詳細を見るには、ZONE_ID環境変数を設定して再実行してください"
