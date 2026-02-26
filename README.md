# ncaq.net Infrastructure as Code

このリポジトリは`ncaq.net`関連のインフラストラクチャをTerraformで管理するための設定です。

## terraformのセットアップ

```zsh
terraform login
```

必要に応じてinitします。

```zsh
terraform init
```

## 環境変数の定義

`.env.sops`に暗号化してコミットしてあります。
direnvによって自動的に読み込まれるようになっています。

編集コマンドは以下の通りです。

```zsh
sops --input-type dotenv --output-type dotenv .env.sops
```

### Cloudflare

以下の環境変数を設定してください。

`CLOUDFLARE_API_TOKEN`

トークンは[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)から作成できます。

Terraform変数はプレフィックス`TF_VAR_`を付けた環境変数で渡します。
以下の環境変数を設定してください。

- `TF_VAR_zone_id`
- `TF_VAR_account_id`

これらは[Cloudflareダッシュボード](https://dash.cloudflare.com/)のドメイン概要ページから確認できます。

#### 必要な権限

読み取り権限は全てです。

書き込み権限は以下です。

- Account Cloudflare Tunnel
- Account:Email Routing Address
- Zone:Cache Rules
- Zone:DNS
- Zone:Dynamic Redirect
- Zone:Email Routing
- Zone:Firewall Services
- Zone:Page Rules
- Zone:zone_settings

### Tailscale

以下の環境変数を設定してください。

- `TAILSCALE_OAUTH_CLIENT_ID`
- `TAILSCALE_OAUTH_CLIENT_SECRET`

これらは、
[Trust credentials - Tailscale](https://login.tailscale.com/admin/settings/trust-credentials)
の画面でOAuthクライアントを作成して取得できます。

#### 必要な権限

読み込み権限は`all:read`です。

書き込み権限は以下です。

- dns
- policy_file
- devices:core
- devices:posture_attributes
- devices:routes
- webhooksservices
- account_settings
- feature_settings
- services
- networking_settings

### Mackerel

以下の環境変数を設定してください。

- `MACKEREL_API_KEY`

APIキーは[Mackerelダッシュボード](https://mackerel.io/my?tab=apikeys)から作成できます。

デバッグ用に使うmkrコマンドや、
MCPが利用する環境変数名は以下の名前になります。

- `MACKEREL_APIKEY`

アンダースコアの有無が異なります。
同じ値で大丈夫です。

Webhook通知の転送先URLはTerraform変数として管理します。
以下の環境変数を設定してください。

- `TF_VAR_mackerel_slack_url`

## 適用

### 変更の確認

```zsh
terraform plan
```

### 変更の適用

```zsh
terraform apply
```

### 状態の確認

```zsh
terraform state list
terraform state show <resource_name>
```

## 転送

認証情報ファイルを出力します。

```zsh
terraform output -raw tunnel_seminar_credentials|tee tunnel-seminar.json
```

適切なサーバに転送してください。
