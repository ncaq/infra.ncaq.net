output "seminar_ipv4" {
  description = "Tailscale IPv4 address of the seminar device"
  value       = one([for addr in data.tailscale_device.this["seminar"].addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))])
}

# `fd7a:115c:a1e0::/48`はTailscaleが全tailnetで使用する固定のIPv6 ULAプレフィックス。
# https://github.com/tailscale/tailscale/blob/main/net/tsaddr/tsaddr.go
output "seminar_ipv6" {
  description = "Tailscale IPv6 address of the seminar device"
  value       = one([for addr in data.tailscale_device.this["seminar"].addresses : addr if can(regex("^fd7a:115c:a1e0:", addr))])
}
