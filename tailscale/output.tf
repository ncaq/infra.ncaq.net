output "seminar_ipv4" {
  description = "Tailscale IPv4 address of the seminar device"
  value       = one([for addr in data.tailscale_device.this["seminar"].addresses : addr if can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+$", addr))])
}

output "seminar_ipv6" {
  description = "Tailscale IPv6 address of the seminar device"
  value       = one([for addr in data.tailscale_device.this["seminar"].addresses : addr if can(regex(":", addr))])
}
