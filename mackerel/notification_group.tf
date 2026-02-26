resource "mackerel_notification_group" "default" {
  name               = "default"
  notification_level = "all"

  child_channel_ids = [mackerel_channel.webhook.id]
}
