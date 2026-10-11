# desc: uv (Python パッケージマネージャー)
# default: on

run() {
  if has uv; then
    skip "uv は既にインストール済み ($(uv --version))"
    return 0
  fi
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ok "uv をインストール (ターミナル再起動で PATH 反映)"
}
