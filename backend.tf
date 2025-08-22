terraform {
  cloud {
    organization = "ncaq"
    workspaces {
      name = "infra-ncaq-net"
    }
  }
}
