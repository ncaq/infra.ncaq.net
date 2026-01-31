resource "tailscale_acl" "this" {
  acl = jsonencode({
    grants = [
      {
        src = ["autogroup:member"],
        dst = ["autogroup:member"],
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
