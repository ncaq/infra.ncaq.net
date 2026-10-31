resource "tailscale_device_subnet_routes" "seminar" {
  device_id = data.tailscale_device.this["seminar"].id
  routes = [
    # exit nodeとして全ての通信を受けます。
    "0.0.0.0/0",
    "::/0",
    # seminar上のCaddyがniks3-publicとgarageを受けている、コンテナのvethのホスト側アドレスです。
    # exit nodeは`0.0.0.0/0`を広告していても自分のLANの範囲はパケットフィルタから外すため、
    # exit node経由の端末がここへ届くには別途サブネットルートとして広告と承認が要ります。
    # 広告する側はdotfilesの`nixos/host/seminar/tailscale-exit-node.nix`で、
    # アドレスは`nixos/host/seminar/machine-mapping.nix`に揃えます。
    # 宛先の許可は`access-policy.tf`の同じアドレスのgrantです。
    "192.168.100.60/32",
    "192.168.100.70/32",
  ]
}
