# desc: tmux プラグインマネージャー (tpm)
# default: on

run() {
  if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
    skip "tpm は既にインストール済み"
  else
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    ok "tpm をインストール (tmux 内で prefix + I でプラグイン取得)"
  fi
}
