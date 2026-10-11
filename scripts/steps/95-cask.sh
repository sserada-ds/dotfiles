# desc: GUI アプリ (macOS: wezterm / slack / discord)
# default: off

run() {
  if ! has brew; then
    err "Homebrew が見つかりません (macOS のみ対応)"
    return 1
  fi
  brew install --cask wezterm slack discord
  ok "GUI アプリのインストール完了"
}
