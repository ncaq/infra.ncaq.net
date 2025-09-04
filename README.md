# ncaq.net Cloudflare Infrastructure as Code

このリポジトリはCloudflareのインフラストラクチャをTerraformで管理するための設定です。

## セットアップ

### 必要な環境変数の設定

Terraform Cloudの管理ダッシュボードで以下の変数を設定してください。

#### Workspace Variables

- `zone_id`
- `account_id`

#### Environment Variables

- `CLOUDFLARE_API_TOKEN` (Sensitiveにチェック)

`CLOUDFLARE_API_TOKEN`は[Cloudflareダッシュボード](https://dash.cloudflare.com/profile/api-tokens)から作成できます。

### `CLOUDFLARE_API_TOKEN`に必要な権限

#### 読み取り権限

全て。

#### 編集権限

- Account Cloudflare Tunnel
- Account:Email Routing Address
- Zone:Cache Rules
- Zone:DNS
- Zone:Email Routing
- Zone:Firewall Services
- Zone:Page Rules
- Zone:zone_settings

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
