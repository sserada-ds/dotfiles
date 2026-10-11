#!/usr/bin/env bash
# dotfiles のシンボリックリンクを削除し、backup/ に退避した元ファイルがあれば復元する

set -uo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

info "シンボリックリンクを削除中..."
while IFS=$'\t' read -r src dest; do
  label="${dest#"$HOME"/}"
  # dotfiles を指しているリンクだけ消す (他のリンクや実体には触らない)
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    rm "$dest"
    ok "削除: $label"
    bak="$(backup_path_for "$dest")"
    if [[ -e "$bak" || -L "$bak" ]]; then
      mv "$bak" "$dest"
      ok "復元: $label (backup/ から)"
    fi
  fi
done < <(link_pairs all)

if [[ -d "$BACKUP_DIR" ]]; then
  warn "backup/ は残してあります。不要なら手動で削除してください: $BACKUP_DIR"
fi
ok "アンインストール完了"
