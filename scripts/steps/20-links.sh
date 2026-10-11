# desc: シンボリックリンク (zsh / tmux / nvim / wezterm など。既存は backup/ へ退避)
# default: on

run() {
  local src dest
  while IFS=$'\t' read -r src dest; do
    link_item "$src" "$dest"
  done < <(link_pairs core)
  ok "リンク作成完了"
}
