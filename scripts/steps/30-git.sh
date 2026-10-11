# desc: Git 設定 (.gitconfig テンプレート / エディタ / ユーザー情報)
# default: on

# 未設定なら対話で入力 (非対話ならスキップ)
ensure_git_config() {
  local key="$1" label="$2" current value
  current="$(git config --global "$key" 2>/dev/null || true)"
  if [[ -n "$current" ]]; then
    ok "$label: $current （既に設定済み）"
    return 0
  fi
  if [[ ! -t 0 ]]; then
    skip "$label （未設定。対話端末で再実行してください）"
    return 0
  fi
  printf '%s%sを入力してください:%s ' "$BLUE" "$label" "$NC"
  read -r value
  if [[ -n "$value" ]]; then
    git config --global "$key" "$value"
    ok "$label: $value"
  else
    skip "$label"
  fi
}

run() {
  if [[ ! -f "$HOME/.gitconfig" ]]; then
    cp "$DOTFILES_DIR/.gitconfig.template" "$HOME/.gitconfig"
    ok ".gitconfig をテンプレートから作成"
  else
    ok ".gitconfig は既に存在します"
  fi

  git config --global core.editor "nvim"
  git config --global commit.template "$HOME/.commit_template"
  git config --global core.excludesfile "$HOME/.gitignore_global"
  ok "エディタ: nvim / テンプレート: ~/.commit_template / ignore: ~/.gitignore_global"

  ensure_git_config user.name "ユーザー名"
  ensure_git_config user.email "メールアドレス"
}
