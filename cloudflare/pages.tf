resource "cloudflare_pages_project" "ncaq_net" {
  account_id        = var.account_id
  name              = "ncaq-net"
  production_branch = "master"

  source = {
    type = "github"
    config = {
      owner                          = "ncaq"
      repo_name                      = "ncaq.net"
      production_deployments_enabled = false
      preview_deployment_setting     = "none"
    }
  }

  deployment_configs = {
    preview    = {}
    production = {}
  }
}

resource "cloudflare_pages_domain" "ncaq_net_apex" {
  account_id   = var.account_id
  project_name = cloudflare_pages_project.ncaq_net.name
  name         = "ncaq.net"
}

resource "cloudflare_dns_record" "root" {
  zone_id = var.zone_id
  name    = "ncaq.net"
  type    = "CNAME"
  content = cloudflare_pages_project.ncaq_net.subdomain
  proxied = true
  ttl     = 1
}

resource "cloudflare_pages_project" "www_ncaq_net" {
  account_id        = var.account_id
  name              = "www-ncaq-net"
  production_branch = "master"

  deployment_configs = {
    preview    = {}
    production = {}
  }
}

resource "cloudflare_pages_domain" "www_ncaq_net_www" {
  account_id   = var.account_id
  project_name = cloudflare_pages_project.www_ncaq_net.name
  name         = "www.ncaq.net"
}

resource "cloudflare_dns_record" "www" {
  zone_id = var.zone_id
  name    = "www.ncaq.net"
  type    = "CNAME"
  content = cloudflare_pages_project.www_ncaq_net.subdomain
  proxied = true
  ttl     = 1
}
