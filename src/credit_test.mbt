///|
test "credit: フロントマターの出典を読み、譜面の右下に出す" {
  let src = "---\nkey: F\ncredit: 「ぞうさん」作詞:まど・みちお 作曲:團伊玖磨 より\n---\n| 1 | 5 |"
  let result = parse(src)
  assert_true(result.errors.is_empty())
  match result.score.meta {
    Some(meta) =>
      assert_eq(
        meta.credit,
        Some(
          "「ぞうさん」作詞:まど・みちお 作曲:團伊玖磨 より",
        ),
      )
    None => fail("meta が無い")
  }
  let html = render_widget_html(src)
  // ディグリーとコードの両方のパネルに出る
  let mark = "<div class=\"chord-credit\">「ぞうさん」作詞:まど・みちお 作曲:團伊玖磨 より</div>"
  assert_eq(html.split(mark).collect().length(), 3)
}

///|
test "credit: 移調した譜面(parse_to_notes_html)にも出る" {
  let src = "---\ncredit: 出典\n---\n| 1 |"
  assert_true(parse_to_notes_html(src, "G").contains("chord-credit"))
}

///|
test "credit: HTML はエスケープする" {
  let html = parse_to_html("---\ncredit: <b>x</b> & y\n---\n| 1 |")
  assert_true(html.contains("&lt;b&gt;x&lt;/b&gt; &amp; y"))
  assert_true(!html.contains("<b>x</b>"))
}

///|
test "credit: 空なら出さない・書かなければ出さない" {
  assert_true(
    !parse_to_html("---\ncredit:\n---\n| 1 |").contains("chord-credit"),
  )
  assert_true(!parse_to_html("| 1 |").contains("chord-credit"))
}

///|
test "credit: JSON の meta に入る" {
  let result = parse("---\ncredit: a\n---\n| 1 |")
  assert_true(result.score.to_json().contains("\"credit\": \"a\""))
}
