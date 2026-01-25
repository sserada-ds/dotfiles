#!/bin/bash
# Claude Code 通知スクリプト
# macOSのネイティブ通知を表示（terminal-notifier使用）

# 引数から通知内容を取得（デフォルト値あり）
TITLE="${1:-🤖 Claude Code}"
SUBTITLE="${2:-通知}"
MESSAGE="${3:-}"

# メッセージが空の場合は、作業ディレクトリと時刻を表示
if [ -z "$MESSAGE" ]; then
  PROJECT_DIR=$(basename "$PWD")
  CURRENT_TIME=$(date "+%H:%M")
  MESSAGE="📁 ${PROJECT_DIR} - ${CURRENT_TIME}"
fi

# terminal-notifierで通知を表示
terminal-notifier \
  -title "$TITLE" \
  -subtitle "$SUBTITLE" \
  -message "$MESSAGE" \
  -sound Glass \
  -group "claude-code"
