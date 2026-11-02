# Tailscaleはタグをサーバやサービス向けのものとして扱い、
# ユーザの端末には付けないことを推奨しています。
# タグを付けると端末はユーザの所有から外れ、ユーザを削除しても端末が残るためです。
# https://tailscale.com/kb/1068/acl-tags
#
# bulletはデスクトップですが、ComfyUIやOllamaのServiceを広告するホストとしても動かすため、
# Serviceの自動承認に必要なタグを付けています。
# このtailnetはユーザが1人なので、ユーザ削除後に端末が残る副作用は実害になりません。
resource "tailscale_device_tags" "bullet" {
  device_id  = data.tailscale_device.this["bullet"].id
  tags       = ["tag:comfyui", "tag:ollama-bullet"]
  depends_on = [tailscale_acl.this]
}

resource "tailscale_device_tags" "seminar" {
  device_id  = data.tailscale_device.this["seminar"].id
  tags       = ["tag:server", "tag:ollama-seminar"]
  depends_on = [tailscale_acl.this]
}
