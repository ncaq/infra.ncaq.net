# ncaq.net Infrastructure as Code

このリポジトリは`ncaq.net`関連のインフラストラクチャをTerraformで管理するための設定です。

## terraformのセットアップ

```bash
terraform login
```

必要に応じてinitします。

```bash
terraform init
```

## Cloudflareの環境変数のセットアップ

Terraform Cloudの管理ダッシュボードで変数を設定してください。

key`cloudflare`の変数をHCL形式で設定してください。
Cloudflareのダッシュボードのドメインの管理画面の右下のAPIセクションから取得できます。

```hcl
{
  zone_id    = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  account_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

env変数としてトークンを設定してください。

トークンは[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)から作成できます。

- `CLOUDFLARE_API_TOKEN`(Sensitiveにチェック)

### `CLOUDFLARE_API_TOKEN`に必要な権限

#### 読み取り権限

全て。

#### 編集権限

- Account Cloudflare Tunnel
- Account:Email Routing Address
- Zone:Cache Rules
- Zone:DNS
- Zone:Dynamic Redirect
- Zone:Email Routing
- Zone:Firewall Services
- Zone:Page Rules
- Zone:zone_settings

## Tailscaleの環境変数のセットアップ

Terraform Cloudの管理ダッシュボードで変数を設定してください。

env変数として以下のOAuthクライアントID/シークレットを設定してください。
これらは[Trust credentials - Tailscale](https://login.tailscale.com/admin/settings/trust-credentials)の画面でOAuthクライアントを作成して取得できます。

- `TAILSCALE_OAUTH_CLIENT_ID`
- `TAILSCALE_OAUTH_CLIENT_SECRET`(Sensitiveにチェック)

## 適用

### 変更の確認

```bash
terraform plan
```

### 変更の適用

```bash
terraform apply
```

### 状態の確認

```bash
terraform state list
terraform state show <resource_name>
```

## 転送

認証情報ファイルを出力します。

```bash
terraform output -raw tunnel_seminar_credentials|tee tunnel-seminar.json
```

適切なサーバに転送してください。
