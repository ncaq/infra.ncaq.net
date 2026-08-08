locals {
  email = "ncaq@ncaq.net"
}

resource "tailscale_contacts" "this" {
  account {
    email = local.email
  }

  support {
    email = local.email
  }

  security {
    email = local.email
  }
}
