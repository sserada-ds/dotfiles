# desc: Claude Code 本体 + settings / hooks / skills / Langfuse 設定
# default: on

install_claude() {
  if has claude; then
    ok "Claude Code は既にインストール済み ($(claude --version 2>/dev/null || echo 'version unknown'))"
  elif has brew; then
    brew install claude
  elif has npm; then
    npm install -g @anthropic-ai/claude-code
  else
    warn "brew / npm が見つかりません。Claude Code のインストールをスキップ"
  fi
}

# dotfiles 側で削除された skill のリンクが ~/.claude/skills に残らないよう掃除する
prune_stale_skill_links() {
  local link
  for link in "$HOME/.claude/skills"/*; do
    [[ -L "$link" ]] || continue
    case "$(readlink "$link")" in
    "$DOTFILES_DIR"/.claude/skills/*)
      if [[ ! -e "$link" ]]; then
        rm "$link"
        ok "削除済み skill のリンクを掃除: skills/$(basename "$link")"
      fi
      ;;
    esac
  done
}

run() {
  install_claude

  # settings.json は Claude Code 自身が書き換えることがあるためコピー (リンクにしない)
  mkdir -p "$HOME/.claude/skills"
  if [[ -f "$DOTFILES_DIR/.claude/settings.json" ]]; then
    cp "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
    ok "settings.json: コピー完了"
  else
    err "settings.json: ソースが見つかりません"
  fi

  # hooks / skills はシンボリックリンク (dotfiles を編集すれば即反映される)
  local src dest
  while IFS=$'\t' read -r src dest; do
    link_item "$src" "$dest"
  done < <(link_pairs claude)
  prune_stale_skill_links

  # Langfuse トレース設定 (API キーは手で入れる)
  mkdir -p "$HOME/.config/langfuse"
  if [[ -f "$HOME/.config/langfuse/.env" ]]; then
    ok "langfuse/.env は既に存在します"
  elif [[ -f "$DOTFILES_DIR/.config/langfuse/.env.example" ]]; then
    cp "$DOTFILES_DIR/.config/langfuse/.env.example" "$HOME/.config/langfuse/.env"
    warn "langfuse/.env をテンプレートから作成しました。API キーを設定してください: ~/.config/langfuse/.env"
  fi
}
