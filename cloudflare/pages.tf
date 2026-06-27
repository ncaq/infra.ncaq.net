resource "cloudflare_pages_project" "ncaq_net" {
  account_id        = var.account_id
  name              = "ncaq-net"
  production_branch = "master"

  build_config = {
    build_command   = ""
    destination_dir = "public"
    root_dir        = ""
  }

  source = {
    type = "github"
    config = {
      owner                          = "ncaq"
      owner_id                       = "2913112"
      repo_name                      = "ncaq.net"
      repo_id                        = "690576986"
      production_branch              = "master"
      pr_comments_enabled            = true
      production_deployments_enabled = false
      preview_deployment_setting     = "none"
      preview_branch_includes        = ["*"]
      path_includes                  = ["*"]
    }
  }

  deployment_configs = {
    preview = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 2
      compatibility_date                   = "2023-09-12"
      fail_open                            = true
    }
    production = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 2
      compatibility_date                   = "2023-09-12"
      fail_open                            = true
    }
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

  build_config = {
    build_command   = ""
    destination_dir = "public"
    root_dir        = ""
  }

  source = {
    type = "github"
    config = {
      owner                          = "ncaq"
      owner_id                       = "2913112"
      repo_name                      = "cdn.ncaq.net"
      repo_id                        = "680426272"
      production_branch              = "master"
      pr_comments_enabled            = true
      production_deployments_enabled = true
      preview_deployment_setting     = "all"
      preview_branch_includes        = ["*"]
      path_includes                  = ["*"]
    }
  }

  deployment_configs = {
    preview = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 2
      compatibility_date                   = "2023-08-19"
      fail_open                            = true
    }
    production = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 2
      compatibility_date                   = "2023-08-19"
      fail_open                            = true
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
    preview = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 1
      compatibility_date                   = "2023-03-01"
      fail_open                            = true
    }
    production = {
      always_use_latest_compatibility_date = false
      build_image_major_version            = 1
      compatibility_date                   = "2023-03-01"
      fail_open                            = true
    }
  }
}

resource "cloudflare_pages_domain" "www_ncaq_net_www" {
  account_id   = var.account_id
  project_name = cloudflare_pages_project.www_ncaq_net.name
  name         = "www.ncaq.net"
}
