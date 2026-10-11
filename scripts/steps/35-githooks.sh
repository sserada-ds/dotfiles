# desc: Git グローバルフック (コミット前の機密情報スキャン / gitleaks)
# default: on

run() {
  local src dest
  while IFS=$'\t' read -r src dest; do
    link_item "$src" "$dest"
  done < <(link_pairs hooks)

  local current
  current="$(git config --global --get core.hooksPath || true)"
  if [[ -n "$current" && "$current" != "$HOME/.config/git/hooks" ]]; then
    warn "core.hooksPath を上書きします (旧: $current)"
  fi
  git config --global core.hooksPath "$HOME/.config/git/hooks"
  ok "core.hooksPath: ~/.config/git/hooks (リポジトリ固有の .git/hooks は引き継ぎます)"

  if has gitleaks; then
    ok "gitleaks は既にインストール済み"
  elif has brew; then
    brew install gitleaks
  else
    warn "gitleaks が見つかりません。自前ルールのみで検査します (https://github.com/gitleaks/gitleaks)"
  fi
}
