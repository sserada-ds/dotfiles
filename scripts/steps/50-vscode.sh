# desc: VSCode 設定リンク + extensions.txt から拡張機能
# default: on

run() {
  info "User dir: $VSCODE_USER_DIR"
  local src dest
  while IFS=$'\t' read -r src dest; do
    link_item "$src" "$dest"
  done < <(link_pairs vscode)

  local list="$DOTFILES_DIR/.config/Code/extensions.txt"
  if ! has code; then
    warn "code コマンドが見つかりません。拡張機能をスキップ"
    echo "  VSCode で Cmd+Shift+P → 'Shell Command: Install code command in PATH'"
    return 0
  fi
  if [[ ! -f "$list" ]]; then
    warn "extensions.txt が見つかりません。スキップ"
    return 0
  fi

  local installed ext
  installed="$(code --list-extensions 2>/dev/null)"
  while IFS= read -r ext; do
    [[ -z "$ext" ]] && continue
    if echo "$installed" | grep -qix "$ext"; then
      skip "$ext （インストール済み）"
    else
      info "  インストール: $ext"
      code --install-extension "$ext" --force >/dev/null 2>&1 || err "失敗: $ext"
    fi
  done <"$list"
  ok "VSCode 設定完了"
}
