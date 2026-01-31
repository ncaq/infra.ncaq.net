module "cloudflare" {
  source     = "./cloudflare"
  zone_id    = var.cloudflare.zone_id
  account_id = var.cloudflare.account_id
}

module "tailscale" {
  source     = "./tailscale"
}
