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

resource "cloudflare_pages_project" "cdn_ncaq_net" {
  account_id        = var.account_id
  name              = "cdn-ncaq-net"
  production_branch = "master"

  source = {
    type = "github"
    config = {
      owner     = "ncaq"
      repo_name = "cdn.ncaq.net"
    }
  }

  deployment_configs = {
    preview = {
      build_image_major_version = 3
    }
    production = {
      build_image_major_version = 3
    }
  }
}

resource "cloudflare_pages_domain" "cdn_ncaq_net_cdn" {
  account_id   = var.account_id
  project_name = cloudflare_pages_project.cdn_ncaq_net.name
  name         = "cdn.ncaq.net"
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
