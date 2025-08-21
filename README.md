# ncaq.net Cloudflare Infrastructure as Code

このリポジトリはCloudflareのインフラストラクチャをOpenTofuで管理するための設定です。

## セットアップ

### 必要な環境変数の設定

```bash
# Cloudflare API Token
export CLOUDFLARE_API_TOKEN="your-api-token-here"

# Zone IDとAccount ID
export TF_VAR_zone_id="your-zone-id"
export TF_VAR_account_id="your-account-id"
```

API Tokenは[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)から作成できます。

API TokenはGitからignoreされている`.env.local`に書き込んでdirenvで読み込むことを想定しています。

#### API Tokenに必要な権限

##### 読み取り権限

全て。

##### 編集権限

- Account:Email Routing Address
- Zone:Cache Rules
- Zone:DNS
- Zone:Email Routing
- Zone:Firewall Services
- Zone:Page Rules

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

## 注意事項

API Tokenは環境変数で管理し、Gitで管理されるファイルにハードコードしない。
