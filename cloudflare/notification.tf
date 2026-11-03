locals {
  notification_email = "ncaq@ncaq.net"
}

resource "cloudflare_notification_policy" "passive_origin_monitoring" {
  account_id  = var.account_id
  name        = "Passive Origin Monitoring"
  description = "Receive an email when your origin becomes unreachable"
  enabled     = true
  alert_type  = "real_origin_monitoring"
  mechanisms = {
    email = [{ id = local.notification_email }]
  }
}

# seminarのTunnelが落ちると配下のサービスが全て止まるので、
# 接続状態の変化を通知する。
# new_statusで状態を絞るフィルタはAPIが受け付けないため、復旧も通知される。
resource "cloudflare_notification_policy" "tunnel_health" {
  account_id  = var.account_id
  name        = "Tunnel Health"
  description = "Tunnelの接続状態が変わった時にメールで通知する"
  enabled     = true
  alert_type  = "tunnel_health_event"
  filters = {
    tunnel_id = [cloudflare_zero_trust_tunnel_cloudflared.seminar.id]
  }
  mechanisms = {
    email = [{ id = local.notification_email }]
  }
}

# Universal SSLの更新に失敗すると全ホストのHTTPSが切れる。
resource "cloudflare_notification_policy" "universal_ssl" {
  account_id  = var.account_id
  name        = "Universal SSL"
  description = "Universal SSL証明書の検証、発行、更新、失効をメールで通知する"
  enabled     = true
  alert_type  = "universal_ssl_event_type"
  mechanisms = {
    email = [{ id = local.notification_email }]
  }
}

resource "cloudflare_notification_policy" "dos_attack_l7" {
  account_id  = var.account_id
  name        = "HTTP DDoS Attack"
  description = "HTTP DDoS攻撃を検出して緩和した時にメールで通知する"
  enabled     = true
  alert_type  = "dos_attack_l7"
  mechanisms = {
    email = [{ id = local.notification_email }]
  }
}

resource "cloudflare_notification_policy" "web_analytics_metrics_update" {
  account_id  = var.account_id
  name        = "Default Web Analytics Metrics Update"
  description = "Default Web Analytics Metrics Update"
  enabled     = true
  alert_type  = "web_analytics_metrics_update"
  mechanisms = {
    email = [{ id = local.notification_email }]
  }
}
