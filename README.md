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

トークンは、
[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)
から作成できます。

Terraform変数はプレフィックス`TF_VAR_`を付けた環境変数で渡します。
以下の環境変数を設定してください。

- `TF_VAR_zone_id`
- `TF_VAR_account_id`

これらは、
[Cloudflareダッシュボード](https://dash.cloudflare.com/)
のドメイン概要ページから確認できます。

#### 必要な権限

読み取り権限は全てです。

書き込み権限は以下です。

- Account:Cloudflare Pages
- Account:Cloudflare Tunnel
- Account:Email Routing Address
- Zone:Cache Rules
- Zone:DNS
- Zone:Dynamic Redirect
- Zone:Email Routing
- Zone:Firewall Services
- Zone:Page Rules
- Zone:SSL and Certificates
- Zone:zone_settings

### Tailscale

以下の環境変数を設定してください。

- `TAILSCALE_OAUTH_CLIENT_ID`
- `TAILSCALE_OAUTH_CLIENT_SECRET`

これらは、
[Trust credentials - Tailscale](https://login.tailscale.com/admin/settings/trust-credentials)
の画面でOAuthクライアントを作成して取得できます。

#### OAuthクライアントをTerraformで管理しない理由

Tailscaleプロバイダには`tailscale_oauth_client`リソースがあり、
OAuthクライアント自体をTerraformで作ることもできますが、
このリポジトリではあえて手作業で作成します。

- Terraformが認証に使う資格情報をTerraform自身に管理させると、
  作り直すたびにapplyの途中で`.env.sops`を手で差し替える工程が挟まり、
  結局IaCだけでは完結しません
- クライアントシークレットが`key`属性としてstateに平文で書かれます。
  stateはTerraform Cloudに置いているため、
  sopsで管理しているシークレットの置き場が1つ増えてしまいます

Terraform Cloudのワークスペースは実行モードがlocalで、
stateの保管だけに使っています。
Terraformの実行もシークレットの読み込みも手元で行うため、
OAuthクライアントを作り直した時に差し替えるのは`.env.sops`だけです。

#### 必要な権限

Terraformが操作するリソースから逆算した最小限のスコープです。
使っていないスコープは付与しません。

読み込み権限は`all:read`です。
`data.tailscale_device`などのdata sourceの読み取りに使います。

書き込み権限は以下です。

| スコープ           | 操作するリソース                                                                  |
| ------------------ | --------------------------------------------------------------------------------- |
| `policy_file`      | `tailscale_acl`                                                                   |
| `devices:core`     | `tailscale_device_authorization`, `tailscale_device_key`, `tailscale_device_tags` |
| `devices:routes`   | `tailscale_device_subnet_routes`                                                  |
| `dns`              | `tailscale_dns_configuration`                                                     |
| `services`         | `tailscale_service`                                                               |
| `account_settings` | `tailscale_contacts`                                                              |
| `feature_settings` | `tailscale_tailnet_settings`                                                      |

`devices:posture_attributes`と`devices:core:read`も付与されます。
Terraformが直接使うわけではありませんが、
`policy_file`を付与する時はこの2つが必須と決められていて、
管理画面で`policy_file`を選ぶと自動的に付与されます。
`devices:core:read`は`devices:core`に含まれるため、
実質的に増えるのは`devices:posture_attributes`だけです。

スコープの一覧と依存関係は
[Trust credentials](https://tailscale.com/kb/1623/trust-credentials)
を参照してください。

#### タグ

`devices:core`スコープを付与するOAuthクライアントにはタグが必須です。
タグ付きのクライアントは、
自分のタグが`tagOwners`で所有しているタグしか端末に付与できません。

このクライアントには`tag:server`を付与します。
`tailscale/access-policy.tf`の`tagOwners`では、
`tag:server`が自分自身とServiceホスト用の各タグを所有するように書いてあり、
これによってTerraformから`tailscale_device_tags`で各タグを付与できます。

#### 端末の追加

tailnet設定で端末承認を有効にしているため、
新しい端末はログインしただけではtailnetに参加できません。
`tailscale/device.tf`の`local.device`にMagicDNS名を追加してapplyすると、
`tailscale_device_authorization`によって承認されます。

### Mackerel

以下の環境変数を設定してください。

- `MACKEREL_API_KEY`

APIキーは、
[Mackerelダッシュボード](https://mackerel.io/my?tab=apikeys)
から作成できます。

デバッグ用に使うmkrコマンドが利用する環境変数名は以下の名前になります。

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
