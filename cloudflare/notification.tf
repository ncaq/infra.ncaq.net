resource "cloudflare_notification_policy" "passive_origin_monitoring" {
  account_id  = var.account_id
  name        = "Passive Origin Monitoring"
  description = "Receive an email when your origin becomes unreachable"
  enabled     = true
  alert_type  = "real_origin_monitoring"
  mechanisms = {
    email = [{ id = "ncaq@ncaq.net" }]
  }
}

resource "cloudflare_notification_policy" "web_analytics_metrics_update" {
  account_id  = var.account_id
  name        = "Default Web Analytics Metrics Update"
  description = "Default Web Analytics Metrics Update"
  enabled     = true
  alert_type  = "web_analytics_metrics_update"
  mechanisms = {
    email = [{ id = "ncaq@ncaq.net" }]
  }
}
