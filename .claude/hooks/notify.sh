#!/bin/bash
# Claude Code 通知スクリプト
# macOS: terminal-notifier / Linux: notify-send

TITLE="${1:-🤖 Claude Code}"
SUBTITLE="${2:-通知}"
MESSAGE="${3:-}"

# メッセージが空の場合は、作業ディレクトリと時刻を表示
if [ -z "$MESSAGE" ]; then
  PROJECT_DIR="${PWD##*/}"
  CURRENT_TIME=$(date "+%H:%M")
  MESSAGE="📁 ${PROJECT_DIR} - ${CURRENT_TIME}"
fi

# プラットフォーム検出して通知
if [[ "$(uname)" == "Darwin" ]]; then
  if command -v terminal-notifier &>/dev/null; then
    terminal-notifier \
      -title "$TITLE" \
      -subtitle "$SUBTITLE" \
      -message "$MESSAGE" \
      -sound Glass \
      -group "claude-code"
  fi
elif command -v notify-send &>/dev/null; then
  notify-send "$TITLE - $SUBTITLE" "$MESSAGE"
fi
