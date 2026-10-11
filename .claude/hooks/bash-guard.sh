#!/usr/bin/env bash
# Claude Code PreToolUse hook (Bash):
#   1) secret-scan の回避 (--no-verify / hooksPath の変更 / フックの改変) をブロック
#   2) コマンド文字列そのものに機密が含まれていたらブロック
# exit 2 + stderr でコマンドを中止し、理由を Claude に返す

command -v jq >/dev/null 2>&1 || exit 0

CMD="$(jq -r '.tool_input.command // empty')"
[[ -n "$CMD" ]] || exit 0

block() {
  {
    echo "bash-guard: $1"
    echo "$2"
  } >&2
  exit 2
}

# 1) フック回避。行単位で判定する (コミットメッセージ本文中の言及は誤検知しない)
BYPASS_MSG="機密情報チェック (pre-commit) の回避はできません。検出された原因を取り除いてください。どうしても必要ならユーザー自身が実行します。"
while IFS= read -r line; do
  if echo "$line" | grep -Eq 'git[^|;&]*[[:space:]](commit|push|merge|rebase)([[:space:]][^|;&]*)?[[:space:]]--no-verify'; then
    block "git の --no-verify は使えません" "$BYPASS_MSG"
  fi
  # -n は短縮形で誤検知しやすいため、引用符内 (コミットメッセージ等) を除いて判定する
  unquoted="$(echo "$line" | sed -E "s/\"[^\"]*\"//g; s/'[^']*'//g")"
  if echo "$unquoted" | grep -Eq 'git[^|;&]*[[:space:]]commit([[:space:]][^|;&]*)?[[:space:]]-[a-zA-Z]*n[a-zA-Z]*([[:space:]]|$)'; then
    block "git commit -n (= --no-verify) は使えません" "$BYPASS_MSG"
  fi
  if echo "$line" | grep -Eq '(^|[[:space:]])(-c[[:space:]]+)?core\.hooksPath(=|[[:space:]])|git[^|;&]*config[^|;&]*hooksPath'; then
    block "core.hooksPath の変更はできません" "$BYPASS_MSG"
  fi
  if echo "$line" | grep -Eq '(^|[[:space:]])(SKIP|HUSKY|LEFTHOOK)=[^[:space:]]*[[:space:]]+git[[:space:]]'; then
    block "フックをスキップする環境変数は使えません" "$BYPASS_MSG"
  fi
  if echo "$line" | grep -Eq '(rm|mv|chmod|ln|truncate|sed[^|;&]*-i|tee)[^|;&]*(\.config/git/hooks|\.git/hooks)'; then
    block "Git フックの削除・改変はできません" "フックの変更が必要なら、ユーザー自身が行います。"
  fi
done <<<"$CMD"

# 2) コマンド内の機密
SCANNER="$HOME/.config/git/hooks/secret-scan"
if [[ -x "$SCANNER" ]]; then
  if ! REPORT="$(printf '%s\n' "$CMD" | "$SCANNER" --stdin "command" 2>&1)"; then
    block "コマンドに機密情報の可能性があります" "$REPORT
値は環境変数や git 管理外の .env から読み込む形に書き直してください。誤検知なら 'allow-secret' を含めてください。"
  fi
fi
exit 0
