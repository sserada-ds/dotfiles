#!/bin/bash
# Claude Code セッションを Langfuse にトレースする Hook スクリプト
#
# 引数: prompt | pre | post | stop | subagent-stop
#
# 設計:
#   - ターン (プロンプト→応答) ごとに1つの trace を作成
#   - sessionId でセッション内のターンをグルーピング
#   - /tmp/claude-turn-{session_id} にターン trace ID を保存して共有
#
# 認証: 環境変数 or ~/workspace/claude-observatory/.env から自動読み込み

set -euo pipefail

PHASE="${1:-}"
INPUT=$(cat)

# ~/.config/langfuse/.env から LANGFUSE_* を読み込む (環境変数未設定時)
if [ -z "${LANGFUSE_PUBLIC_KEY:-}" ] || [ -z "${LANGFUSE_SECRET_KEY:-}" ]; then
  ENV_FILE="${HOME}/.config/langfuse/.env"
  if [ -f "$ENV_FILE" ]; then
    while IFS='=' read -r key value; do
      case "$key" in
        LANGFUSE_*) export "$key=$value" ;;
      esac
    done < <(command grep '^LANGFUSE_' "$ENV_FILE")
  fi
fi

# 認証情報がなければ何もしない
if [ -z "${LANGFUSE_PUBLIC_KEY:-}" ] || [ -z "${LANGFUSE_SECRET_KEY:-}" ]; then
  exit 0
fi

BASE_URL="${LANGFUSE_BASE_URL:-http://localhost:3000}"
AUTH=$(echo -n "${LANGFUSE_PUBLIC_KEY}:${LANGFUSE_SECRET_KEY}" | base64 | tr -d '\n')

# --- 共通フィールド ---
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')
TOOL_USE_ID=$(echo "$INPUT" | jq -r '.tool_use_id // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // "unknown"')
REPO_ROOT=$(cd "$CWD" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null || echo "$CWD")
PROJECT_NAME=$(basename "$REPO_ROOT")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# --- Git コンテキスト ---
GIT_BRANCH=$(cd "$CWD" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
GIT_COMMIT=$(cd "$CWD" 2>/dev/null && git rev-parse --short HEAD 2>/dev/null || echo "")

# --- CLAUDE.md バージョニング ---
CLAUDE_MD_HASH=""
for candidate in "$REPO_ROOT/CLAUDE.md" "$CWD/CLAUDE.md"; do
  if [ -f "$candidate" ]; then
    CLAUDE_MD_HASH=$(shasum -a 256 "$candidate" 2>/dev/null | head -c 8)
    break
  fi
done

# --- セッション ID (プロジェクト名付き) ---
SESSION_SHORT=$(echo "$SESSION_ID" | head -c 8)
LANGFUSE_SESSION_ID="${PROJECT_NAME}/${SESSION_SHORT}"

# ターン trace ID の保存/取得
TURN_FILE="/tmp/claude-turn-${SESSION_ID}"

save_turn_id() { echo "$1" > "$TURN_FILE"; }
get_turn_id() { cat "$TURN_FILE" 2>/dev/null || echo "$SESSION_ID"; }

post_to_langfuse() {
  curl -s -X POST "${BASE_URL}/api/public/ingestion" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic ${AUTH}" \
    -d "$1" > /dev/null 2>&1 || true
}

case "$PHASE" in
  prompt)
    USER_PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')
    TURN_ID="${SESSION_ID}-$(date +%s%N | head -c 16)"
    save_turn_id "$TURN_ID"

    post_to_langfuse "$(jq -n \
      --arg tid "$TURN_ID" \
      --arg sid "$LANGFUSE_SESSION_ID" \
      --arg ts "$TIMESTAMP" \
      --arg prompt "$USER_PROMPT" \
      --arg cwd "$CWD" \
      --arg proj "$PROJECT_NAME" \
      --arg repo "$REPO_ROOT" \
      --arg branch "$GIT_BRANCH" \
      --arg commit "$GIT_COMMIT" \
      --arg claude_md "$CLAUDE_MD_HASH" \
      '{
        batch: [{
          id: ("trace-" + $tid),
          type: "trace-create",
          timestamp: $ts,
          body: {
            id: $tid,
            sessionId: $sid,
            name: ("claude-code:" + $proj),
            timestamp: $ts,
            input: { prompt: $prompt },
            metadata: (
              {
                source: "claude-code-hook",
                repo_root: $repo,
                project_dir: $cwd,
                project_name: $proj,
                git_branch: $branch,
                git_commit: $commit
              } + if $claude_md != "" then { claude_md_hash: $claude_md } else {} end
            ),
            tags: (["claude-code", $proj] + if $branch != "" then [$branch] else [] end)
          }
        }]
      }'
    )"
    ;;
  pre)
    TURN_ID=$(get_turn_id)
    TOOL_INPUT=$(echo "$INPUT" | jq -c '.tool_input // {}')
    post_to_langfuse "$(jq -n \
      --arg tid "$TURN_ID" \
      --arg tuid "$TOOL_USE_ID" \
      --arg tool "$TOOL_NAME" \
      --arg ts "$TIMESTAMP" \
      --arg cwd "$CWD" \
      '{
        batch: [{
          id: ("span-pre-" + $tuid),
          type: "span-create",
          timestamp: $ts,
          body: {
            id: ("span-" + $tuid),
            traceId: $tid,
            name: $tool,
            startTime: $ts,
            input: ($ARGS.named.ti),
            metadata: {
              tool_name: $tool,
              tool_use_id: $tuid,
              cwd: $cwd
            }
          }
        }]
      }' --argjson ti "$TOOL_INPUT"
    )"
    ;;
  post)
    TURN_ID=$(get_turn_id)
    STDOUT=$(echo "$INPUT" | jq -r '.tool_response.stdout // ""' | head -c 4000)
    STDERR=$(echo "$INPUT" | jq -r '.tool_response.stderr // ""' | head -c 2000)
    HAS_ERROR=$([ -n "$STDERR" ] && echo "true" || echo "false")

    # エラーがある場合、trace にタグを追加
    BATCH=$(jq -n \
      --arg tid "$TURN_ID" \
      --arg tuid "$TOOL_USE_ID" \
      --arg tool "$TOOL_NAME" \
      --arg ts "$TIMESTAMP" \
      --arg stdout "$STDOUT" \
      --arg stderr "$STDERR" \
      --argjson has_error "$HAS_ERROR" \
      '{
        batch: [{
          id: ("span-post-" + $tuid),
          type: "span-update",
          timestamp: $ts,
          body: {
            id: ("span-" + $tuid),
            traceId: $tid,
            endTime: $ts,
            output: {
              stdout: $stdout,
              stderr: $stderr
            },
            level: (if $has_error then "ERROR" else "DEFAULT" end),
            metadata: {
              tool_name: $tool,
              tool_use_id: $tuid,
              has_error: $has_error
            }
          }
        }]
      }'
    )

    # stderr がある場合、trace にも error タグを付与
    if [ "$HAS_ERROR" = "true" ]; then
      BATCH=$(echo "$BATCH" | jq \
        --arg tid "$TURN_ID" \
        --arg ts "$TIMESTAMP" \
        --arg proj "$PROJECT_NAME" \
        --arg branch "$GIT_BRANCH" \
        '.batch += [{
          id: ("trace-error-" + $tid + "-" + $ts),
          type: "trace-create",
          timestamp: $ts,
          body: {
            id: $tid,
            tags: (["claude-code", $proj, "error"] + if $branch != "" then [$branch] else [] end)
          }
        }]'
      )
    fi

    post_to_langfuse "$BATCH"
    ;;
  stop)
    TURN_ID=$(get_turn_id)
    ASSISTANT_MSG=$(echo "$INPUT" | jq -r '.last_assistant_message // ""' | head -c 4000)
    post_to_langfuse "$(jq -n \
      --arg tid "$TURN_ID" \
      --arg ts "$TIMESTAMP" \
      --arg cwd "$CWD" \
      --arg output "$ASSISTANT_MSG" \
      '{
        batch: [
          {
            id: ("trace-stop-" + $tid),
            type: "trace-create",
            timestamp: $ts,
            body: {
              id: $tid,
              output: { response: $output }
            }
          },
          {
            id: ("evt-stop-" + $tid + "-" + $ts),
            type: "event-create",
            timestamp: $ts,
            body: {
              id: ("evt-stop-" + $tid + "-" + $ts),
              traceId: $tid,
              name: "turn-complete",
              startTime: $ts,
              metadata: {
                event: "stop",
                cwd: $cwd
              }
            }
          }
        ]
      }'
    )"
    ;;
  subagent-stop)
    TURN_ID=$(get_turn_id)
    post_to_langfuse "$(jq -n \
      --arg tid "$TURN_ID" \
      --arg ts "$TIMESTAMP" \
      --arg cwd "$CWD" \
      '{
        batch: [{
          id: ("evt-subagent-" + $tid + "-" + $ts),
          type: "event-create",
          timestamp: $ts,
          body: {
            id: ("evt-subagent-" + $tid + "-" + $ts),
            traceId: $tid,
            name: "subagent-complete",
            startTime: $ts,
            metadata: {
              event: "subagent_stop",
              cwd: $cwd
            }
          }
        }]
      }'
    )"
    ;;
esac

exit 0
