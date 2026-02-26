resource "mackerel_channel" "slack" {
  name = "slack"

  slack {
    url    = var.slack_url
    events = ["alert", "alertGroup", "hostStatus", "hostRegister", "hostRetire", "monitor"]
  }
}
