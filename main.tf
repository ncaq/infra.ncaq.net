module "cloudflare" {
  source     = "./cloudflare"
  zone_id    = var.zone_id
  account_id = var.account_id
}
