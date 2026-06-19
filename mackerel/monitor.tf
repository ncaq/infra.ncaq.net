resource "mackerel_monitor" "connectivity" {
  name = "connectivity"

  connectivity {
    alert_status_on_gone = "CRITICAL"
  }
}

resource "mackerel_monitor" "filesystem" {
  name = "filesystem"

  # disk%はMackerelの「ファイルシステム使用率」専用メトリック種別で、
  # ホスト上の全ファイルシステムのうち使用率が最も高いものを閾値と比較する。
  # 空き領域が1割を切る = 使用率が90%を超えることを異常扱いとする。
  host_metric {
    metric   = "disk%"
    operator = ">"
    critical = 90
    duration = 3
  }
}
