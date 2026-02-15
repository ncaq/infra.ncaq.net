resource "cloudflare_dns_record" "mcp-nixos" {
  zone_id = var.zone_id
  name    = "mcp-nixos.ncaq.net"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.seminar.id}.cfargotunnel.com"
  proxied = true
  ttl     = 1
}

# mcp-nixos subdomainのfaviconをmcp-nixosリポジトリのものにリダイレクトします。
# fastmcpはfaviconを提供しないため、ブラウザがncaq.netのfaviconにフォールバックしてしまうのを防ぎます。
resource "cloudflare_ruleset" "mcp-nixos_redirect" {
  zone_id = var.zone_id
  name    = "mcp-nixos redirects"
  kind    = "zone"
  phase   = "http_request_dynamic_redirect"

  rules = [
    {
      action      = "redirect"
      description = "Redirect favicon.ico to mcp-nixos repository favicon"
      enabled     = true
      expression  = "(http.host eq \"mcp-nixos.ncaq.net\" and http.request.uri.path eq \"/favicon.ico\")"

      action_parameters = {
        from_value = {
          status_code = 302
          target_url = {
            value = "https://raw.githubusercontent.com/utensils/mcp-nixos/main/website/public/favicon/favicon.ico"
          }
          preserve_query_string = false
        }
      }
    }
  ]
}
