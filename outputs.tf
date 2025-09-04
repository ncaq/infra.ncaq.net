output "tunnel_seminar_credentials" {
  value       = module.cloudflare.tunnel_seminar_credentials
  sensitive   = true
  description = "Credentials for running cloudflared"
}
