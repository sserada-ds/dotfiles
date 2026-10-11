# desc: SuperClaude Framework (pipx。deps と claude が先に必要)
# default: on

run() {
  export PATH="$HOME/.local/bin:$PATH"
  if ! has pipx; then
    err "pipx が見つかりません。先に deps を実行してください"
    return 1
  fi
  if pipx list | grep -q superclaude; then
    skip "SuperClaude は既にインストール済み"
  else
    pipx install superclaude
  fi
  superclaude install
  ok "SuperClaude のインストール完了"
}
