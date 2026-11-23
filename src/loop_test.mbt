///|
test "widget: 再生ボタンの左隣にループ再生のスイッチがある" {
  let html = render_widget_html("| 1 |")
  let loop_at = html.find("class=\"chord-loop\"").unwrap()
  let play_at = html.find("class=\"chord-play\"").unwrap()
  assert_true(loop_at < play_at)
  assert_true(html.contains("aria-pressed=\"false\" title=\"ループ再生\""))
}
