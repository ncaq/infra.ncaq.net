resource "mackerel_channel" "webhook" {
  name = "webhook"

  webhook {
    url    = var.webhook_url
    events = ["alert", "alertGroup", "hostStatus", "monitor"]
  }
}
