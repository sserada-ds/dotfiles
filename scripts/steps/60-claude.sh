# desc: Claude Code 本体 + settings / hooks / skills / Langfuse 設定
# default: on

# copy_dir <name> <required:yes|no>: .claude/<name>/ を ~/.claude/<name>/ へコピー (空でも可)
copy_dir() {
  local name="$1" required="$2"
  local src="$DOTFILES_DIR/.claude/$name" dest="$HOME/.claude/$name"
  if [[ ! -d "$src" ]]; then
    if [[ "$required" == "yes" ]]; then err "$name/: ソースが見つかりません"; else skip "$name/ （ソースなし）"; fi
    return 0
  fi
  mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  ok "$name/: コピー完了"
}

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

run() {
  install_claude

  mkdir -p "$HOME/.claude"
  if [[ -f "$DOTFILES_DIR/.claude/settings.json" ]]; then
    cp "$DOTFILES_DIR/.claude/settings.json" "$HOME/.claude/settings.json"
    ok "settings.json: コピー完了"
  else
    err "settings.json: ソースが見つかりません"
  fi

  copy_dir hooks yes
  chmod +x "$HOME/.claude/hooks/"*.sh 2>/dev/null || true
  copy_dir commands no
  copy_dir skills no

  # Langfuse トレース設定 (API キーは手で入れる)
  mkdir -p "$HOME/.config/langfuse"
  if [[ -f "$HOME/.config/langfuse/.env" ]]; then
    ok "langfuse/.env は既に存在します"
  elif [[ -f "$DOTFILES_DIR/.config/langfuse/.env.example" ]]; then
    cp "$DOTFILES_DIR/.config/langfuse/.env.example" "$HOME/.config/langfuse/.env"
    warn "langfuse/.env をテンプレートから作成しました。API キーを設定してください: ~/.config/langfuse/.env"
  fi
}
