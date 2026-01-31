module "cloudflare" {
  source                 = "./cloudflare"
  zone_id                = var.cloudflare.zone_id
  account_id             = var.cloudflare.account_id
  seminar_tailscale_ipv4 = module.tailscale.seminar_ipv4
  seminar_tailscale_ipv6 = module.tailscale.seminar_ipv6
}

module "tailscale" {
  source = "./tailscale"
}
