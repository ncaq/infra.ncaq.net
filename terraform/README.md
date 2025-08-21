# Cloudflare Infrastructure as Code

このディレクトリはCloudflareのインフラストラクチャをOpenTofuで管理するための設定です。

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

- Zone:Read
- Zone:DNS:Edit
- Zone:Page Rules:Edit
- Zone:Firewall Services:Edit

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
