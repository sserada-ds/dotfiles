# desc: Ollama + qwen2.5-coder:7b (約 4.7GB のダウンロード)
# default: off

MODEL="qwen2.5-coder:7b"

run() {
  if has ollama; then
    skip "Ollama は既にインストール済み"
  elif [[ "$OS" == "Darwin" ]]; then
    brew install ollama
  else
    curl -fsSL https://ollama.com/install.sh | sh
  fi

  if [[ "$OS" == "Darwin" ]]; then
    brew services list | grep -q "ollama.*started" || {
      brew services start ollama
      sleep 3
    }
  elif has systemctl; then
    sudo systemctl enable ollama 2>/dev/null || true
    sudo systemctl start ollama 2>/dev/null || true
    sleep 3
  fi

  warn "$MODEL をダウンロードします (約 4.7GB)"
  ollama pull "$MODEL"
  ok "Ollama 完了 (使い方: ollama run $MODEL)"
}
