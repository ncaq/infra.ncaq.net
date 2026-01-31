resource "tailscale_acl" "this" {
  acl = jsonencode({
    grants = [
      {
        src = ["*"],
        dst = ["*"],
        ip  = ["*"],
      },
    ],
    ssh = [
      {
        action = "check",
        src    = ["autogroup:member"],
        dst    = ["autogroup:self"],
        users  = ["autogroup:nonroot"],
      },
    ],
  })
}
