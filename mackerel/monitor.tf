resource "mackerel_monitor" "connectivity" {
  name = "connectivity"

  connectivity {
    alert_status_on_gone = "CRITICAL"
  }
}
