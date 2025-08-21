# Cloudflare Infrastructure as Code

このディレクトリはCloudflareのインフラストラクチャをOpenTofuで管理するための設定です。

## セットアップ

### 1. 必要な環境変数の設定

```bash
# Cloudflare API Token（必須）
export CLOUDFLARE_API_TOKEN="your-api-token-here"

# Zone IDとAccount ID
export TF_VAR_zone_id="your-zone-id"
export TF_VAR_account_id="your-account-id"
```

API Tokenは[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)から作成できます。
必要な権限:

- Zone:Read
- Zone:DNS:Edit
- Zone:Page Rules:Edit
- Zone:Firewall Services:Edit

### 2. terraform.tfvarsの作成

```bash
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsを編集して実際の値を設定
```

### 3. 既存リソースのID取得

```bash
# CloudflareのリソースIDを確認
./get-cloudflare-ids.sh

# 特定ゾーンの詳細を確認
ZONE_ID="your-zone-id" ./get-cloudflare-ids.sh
```

### 4. Terraformの初期化

```bash
tofu init
```

## 既存リソースのインポート

### DNSレコードのインポート

1. `import.tf`にリソース定義を追加:

```hcl
resource "cloudflare_record" "www" {
  zone_id = var.zone_id
  name    = "www"
  type    = "A"
  value   = "192.0.2.1"
  proxied = true
}
```

2. インポート実行:

```bash
tofu import cloudflare_record.www <zone_id>/<record_id>
```

3. 実際の設定を確認して調整:

```bash
tofu plan
```

### その他のリソース

- **ページルール**: `tofu import cloudflare_page_rule.example <zone_id>/<page_rule_id>`
- **ファイアウォールルール**: `tofu import cloudflare_ruleset.example <zone_id>/<ruleset_id>`
- **SSL/TLS設定**: `tofu import cloudflare_zone_settings_override.example <zone_id>`

## 運用

### 変更の確認

```bash
tofu plan
```

### 変更の適用

```bash
tofu apply
```

### 状態の確認

```bash
tofu state list
tofu state show <resource_name>
```

## ディレクトリ構造

```
terraform/
├── versions.tf          # Terraformバージョンとプロバイダー要件
├── provider.tf          # Cloudflareプロバイダー設定
├── variables.tf         # 変数定義
├── backend.tf           # 状態管理設定
├── import.tf            # インポート用の一時ファイル
├── terraform.tfvars.example  # 変数値の例
├── get-cloudflare-ids.sh    # リソースID取得スクリプト
└── import-commands.sh       # インポートコマンド例
```

## 注意事項

- API Tokenは環境変数で管理し、コードにハードコードしない
- `terraform.tfvars`はGitにコミットしない（.gitignoreに追加済み）
- インポート後は`import.tf`から適切なファイルにリソース定義を移動する
- 本番環境での変更前は必ず`tofu plan`で確認する
