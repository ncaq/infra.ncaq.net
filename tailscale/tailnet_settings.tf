resource "tailscale_tailnet_settings" "this" {
  acls_external_link                          = "https://github.com/ncaq/infra.ncaq.net"
  acls_externally_managed_on                  = true
  devices_approval_on                         = false
  devices_auto_updates_on                     = true
  devices_key_duration_days                   = 180
  https_enabled                               = true
  users_approval_on                           = true
  users_role_allowed_to_join_external_tailnet = "admin"
}
