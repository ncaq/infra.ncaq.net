output "tunnel_seminar_credentials" {
  value = jsonencode({
    AccountTag   = var.account_id
    TunnelSecret = base64encode(random_password.seminar.result)
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.seminar.id
    Endpoint     = ""
  })
  sensitive   = true
  description = "サーバ側にコピーするための認証情報"
}
