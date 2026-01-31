resource "tailscale_tailnet_settings" "this" {
  devices_approval_on                         = false
  devices_auto_updates_on                     = true
  devices_key_duration_days                   = 180
  users_approval_on                           = true
  users_role_allowed_to_join_external_tailnet = "admin"
  network_flow_logging_on                     = false
  regional_routing_on                         = false
  posture_identity_collection_on              = false
  https_enabled                               = true
}
