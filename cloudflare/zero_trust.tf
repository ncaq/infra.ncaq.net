resource "cloudflare_zero_trust_organization" "ncaq_net" {
  account_id                                  = var.account_id
  name                                        = "ncaq-net.cloudflareaccess.com"
  auth_domain                                 = "ncaq-net.cloudflareaccess.com"
  deny_unmatched_requests                     = false
  deny_unmatched_requests_exempted_zone_names = []

  # 無効の時はAPIがenabledしか返さないが、
  # providerはactionとinactivity_threshold_daysも必須としていて現状を表現できない。
  lifecycle {
    ignore_changes = [service_token_inactivity]
  }
}

resource "cloudflare_zero_trust_access_identity_provider" "onetimepin" {
  account_id = var.account_id
  name       = ""
  type       = "onetimepin"
  config     = {}
}
