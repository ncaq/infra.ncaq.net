locals {
  # seminar上のCaddyがgarageを受けている、コンテナのvethのホスト側アドレスです。
  # コンテナとのやり取りはIPv6で行うので、vethのホスト側アドレスはIPv6のULAです。
  # exit nodeの`::/0`に任せると、
  # exit node経由の端末がここへ届くかは`autogroup:internet`にULAが含まれるかどうかに依存します。
  # 別途サブネットルートとして広告と承認をして、`access-policy.tf`で宛先を明示的に許可します。
  # IPv4のアドレスだった頃は、
  # exit nodeが自分のLANやRFC 1918の範囲をパケットフィルタから外すので、これが無いと届きませんでした。
  # 広告する側はdotfilesの`nixos/host/seminar/tailscale-exit-node.nix`で、
  # アドレスは`nixos/host/seminar/machine-mapping.nix`に揃えます。
  #
  # 経路の承認と`access-policy.tf`の宛先の許可の両方がここを参照します。
  # 片方だけ変えると経路はあるのにACLで捨てられる状態になり、
  # Terraformでは検出できないので、1箇所にまとめています。
  seminar_caddy_internal_routes = {
    garage = "fdf2:a855:5a3f:100::60/128"
  }
}

resource "tailscale_device_subnet_routes" "seminar" {
  device_id = data.tailscale_device.this["seminar"].id
  routes = concat(
    # exit nodeとして全ての通信を受けます。
    ["0.0.0.0/0", "::/0"],
    values(local.seminar_caddy_internal_routes),
  )
}
