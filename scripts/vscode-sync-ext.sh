#!/usr/bin/env bash
# 現在インストール済みの VSCode 拡張機能を extensions.txt に書き出す

set -euo pipefail
# shellcheck source=lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if ! has code; then
  err "code コマンドが見つかりません"
  exit 1
fi

out="$DOTFILES_DIR/.config/Code/extensions.txt"
code --list-extensions >"$out"
ok "extensions.txt を更新: $(wc -l <"$out" | tr -d ' ') 個の拡張機能"
