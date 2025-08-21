#!/usr/bin/env bash
set -euo pipefail

# Cloudflareリソースのインポートコマンド

# 環境変数のチェック
if [[ -z ${TF_VAR_zone_id} ]]; then
  echo "エラー: TF_VAR_zone_id環境変数を設定してください" >&2
  exit 1
fi

# CNAME
tofu import cloudflare_record.cdn "${TF_VAR_zone_id}"/62d9a6cd6c5fdde0f0cef75b46d1dc3c
tofu import cloudflare_record.em8260 "${TF_VAR_zone_id}"/4b07b133cdc9e2b5e36e457f7961f9b6
tofu import cloudflare_record.root "${TF_VAR_zone_id}"/d39c2b3d501e3c8e360f0b99a474015e
tofu import cloudflare_record.s1_domainkey "${TF_VAR_zone_id}"/4b8a3798046be404fd4161381df181e3
tofu import cloudflare_record.s2_domainkey "${TF_VAR_zone_id}"/e008383d42d11729fc91dc6c1f78007d
tofu import cloudflare_record.tt_rss "${TF_VAR_zone_id}"/563771465a82cf54a88b82b05d209730
tofu import cloudflare_record.www "${TF_VAR_zone_id}"/bb62a3c2a6685f0879d48316ce58efe5

# MX
tofu import cloudflare_record.mx_route1 "${TF_VAR_zone_id}"/06e0cd3a1dbb4a7f5f7154c93753dcfd
tofu import cloudflare_record.mx_route2 "${TF_VAR_zone_id}"/8b867bb916aa45462a8a81305d2d9df0
tofu import cloudflare_record.mx_route3 "${TF_VAR_zone_id}"/e6af1de774a59d67c9a9cba3a5afe5f9

# SRV
tofu import cloudflare_record.srv_imap "${TF_VAR_zone_id}"/1dc67d3813977c3d6d51958b8089b3c5
tofu import cloudflare_record.srv_smtp "${TF_VAR_zone_id}"/526608788e14bf375cda72b7dbc0cead

# TXT
tofu import cloudflare_record.txt_acme_challenge_cdn "${TF_VAR_zone_id}"/3352f637b47c12fc0de54802cceec255
tofu import cloudflare_record.txt_atproto "${TF_VAR_zone_id}"/ee7c5bce83f38ac289cf59ac361bd089
tofu import cloudflare_record.txt_dkim_cf2024 "${TF_VAR_zone_id}"/d09c17e21bfccea8d5e576994877ee79
tofu import cloudflare_record.txt_discord "${TF_VAR_zone_id}"/39f7cee3ea80b36837cb56a058fa489a
tofu import cloudflare_record.txt_dmarc "${TF_VAR_zone_id}"/11c506b8a956e6475e980ce4094035eb
tofu import cloudflare_record.txt_openai "${TF_VAR_zone_id}"/94b6c1c2e2b104804c80b14d94ad43d8
tofu import cloudflare_record.txt_spf "${TF_VAR_zone_id}"/605632704adea9c01059d90fa42b132d
tofu import cloudflare_record.txt_google_verification "${TF_VAR_zone_id}"/20cbf7f7de57b95f4d527b75dad9bce6

# ページルール
tofu import cloudflare_page_rule.cdn_cache "${TF_VAR_zone_id}"/842c408724c4421590d4b905d6012b8e
