#!/usr/bin/env bash
# Claude Code PreToolUse hook: Write/Edit の内容に機密情報が含まれていたらブロックする
# スキャナは Git グローバルフックと共通 (~/.config/git/hooks/secret-scan)
# exit 2 + stderr でツール実行を中止し、理由を Claude に返す

SCANNER="$HOME/.config/git/hooks/secret-scan"
[[ -x "$SCANNER" ]] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

INPUT="$(cat)"
FILE="$(echo "$INPUT" | jq -r '.tool_input.file_path // "unknown"')"
CONTENT="$(echo "$INPUT" | jq -r '
  [ .tool_input.content,
    .tool_input.new_string,
    (.tool_input.edits[]?.new_string) ]
  | map(select(. != null)) | join("\n")')"

[[ -z "$CONTENT" ]] && exit 0

if ! REPORT="$(printf '%s\n' "$CONTENT" | "$SCANNER" --stdin "$FILE" 2>&1)"; then
  {
    echo "secret-guard: 書き込もうとした内容に機密情報の可能性があります ($FILE)"
    echo "$REPORT"
    echo "値を環境変数や git 管理外の .env に移して書き直してください。誤検知なら行に 'allow-secret' を含めてください。"
  } >&2
  exit 2
fi
exit 0
