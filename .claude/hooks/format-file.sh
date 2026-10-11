#!/usr/bin/env bash
# Claude Code PostToolUse hook: Edit/Write したファイル 1 つだけを整形する
#
# 以前の `make format` (リポジトリ全体) と違い、編集していないファイルには触れない。
# プロジェクト側に設定がある場合だけ整形する (他プロジェクトの流儀を勝手に変えない):
#   prettier : .prettierrc* / prettier.config.* / package.json の "prettier"
#   shfmt    : .editorconfig
#   stylua   : stylua.toml / .stylua.toml
# 失敗しても作業は止めない (常に exit 0)。

command -v jq >/dev/null 2>&1 || exit 0

# macOS には timeout が無いことがあるため、あれば使う
run_limited() {
  if command -v timeout >/dev/null 2>&1; then timeout 20 "$@"; elif command -v gtimeout >/dev/null 2>&1; then gtimeout 20 "$@"; else "$@"; fi
}

FILE="$(jq -r '.tool_input.file_path // empty')"
[[ -n "$FILE" && -f "$FILE" ]] || exit 0

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
# プロジェクト外のファイル (~/.zshrc など) は触らない
case "$FILE" in
"$ROOT"/*) ;;
*) exit 0 ;;
esac

# 生成物や整形対象外
case "$(basename "$FILE")" in
p10k.zsh | zinit.zsh | lazy-lock.json | package-lock.json) exit 0 ;;
esac

# ファイルから上位ディレクトリへ向かって、設定ファイルを探す
find_up() {
  local dir
  dir="$(dirname "$FILE")"
  while [[ "$dir" == "$ROOT" || "$dir" == "$ROOT"/* ]]; do
    local name
    for name in "$@"; do
      [[ -e "$dir/$name" ]] && return 0
    done
    dir="$(dirname "$dir")"
  done
  return 1
}

has_prettier_config() {
  find_up .prettierrc .prettierrc.json .prettierrc.yml .prettierrc.yaml .prettierrc.js .prettierrc.cjs \
    .prettierrc.mjs .prettierrc.toml prettier.config.js prettier.config.cjs prettier.config.mjs && return 0
  [[ -f "$ROOT/package.json" ]] && grep -q '"prettier"' "$ROOT/package.json"
}

case "$FILE" in
*.md | *.json | *.jsonc | *.yml | *.yaml | *.css | *.scss | *.html | *.js | *.jsx | *.ts | *.tsx | *.mjs | *.cjs)
  if command -v prettier >/dev/null 2>&1 && has_prettier_config; then
    (cd "$ROOT" && run_limited prettier --write "$FILE" --log-level silent) >/dev/null 2>&1 || true
  fi
  ;;
*.sh | *.bash | *.zsh)
  if command -v shfmt >/dev/null 2>&1 && find_up .editorconfig; then
    run_limited shfmt -w "$FILE" >/dev/null 2>&1 || true
  fi
  ;;
*.lua)
  if command -v stylua >/dev/null 2>&1 && find_up stylua.toml .stylua.toml; then
    (cd "$ROOT" && run_limited stylua "$FILE") >/dev/null 2>&1 || true
  fi
  ;;
esac
exit 0
