#!/usr/bin/env bash
# 現在のリンク状態と Git 設定を確認する

set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

info "=== リンク状態 ==="
while IFS=$'\t' read -r src dest; do
  label="${dest#"$HOME"/}"
  if [[ -L "$dest" ]]; then
    target="$(readlink "$dest")"
    if [[ "$target" == "$src" ]]; then
      echo "${GREEN}✓${NC} $label -> $target"
    else
      echo "${YELLOW}!${NC} $label -> $target ${YELLOW}(別のターゲット)${NC}"
    fi
  elif [[ -e "$dest" ]]; then
    echo "${RED}✗${NC} $label ${RED}(リンクではありません)${NC}"
  else
    echo "${RED}✗${NC} $label ${RED}(存在しません)${NC}"
  fi
done < <(link_pairs all)

echo ""
info "=== Git 設定 ==="
echo "エディタ:             $(git config --global core.editor || echo '未設定')"
echo "コミットテンプレート: $(git config --global commit.template || echo '未設定')"
echo "グローバル.gitignore: $(git config --global core.excludesfile || echo '未設定')"
echo "Git フック (機密スキャン): $(git config --global core.hooksPath || echo '未設定')"

if [[ -d "$BACKUP_DIR" ]]; then
  echo ""
  info "=== バックアップ ==="
  echo "${GREEN}✓${NC} $BACKUP_DIR"
fi
