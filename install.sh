#!/usr/bin/env bash
# dotfiles セットアップのエントリーポイント
#
#   ./install.sh               対話メニューで項目を選んで実行 (fzf)
#   ./install.sh --all         標準セットを非対話で実行
#   ./install.sh --only a,b    指定した項目だけ実行
#   ./install.sh --list        選べる項目を一覧表示
#
# 項目は scripts/steps/NN-<name>.sh を追加するだけで増やせる。
#   # desc:    メニューに出す説明
#   # default: on|off  (--all とメニューの初期選択に含めるか)
#   run() { ... }

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib.sh
source "$ROOT/scripts/lib.sh"

STEPS_DIR="$ROOT/scripts/steps"

step_name() { basename "$1" .sh | sed 's/^[0-9]*-//'; }
step_meta() { sed -n "s/^# $2: *//p" "$1" | head -1; }

# 全項目を "name<TAB>default<TAB>desc" で出力 (ファイル名順 = 実行順)
list_steps() {
  local f
  for f in "$STEPS_DIR"/*.sh; do
    printf '%s\t%s\t%s\n' "$(step_name "$f")" "$(step_meta "$f" default)" "$(step_meta "$f" desc)"
  done
}

usage() {
  sed -n '2,/^$/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

print_list() {
  list_steps | while IFS=$'\t' read -r name def desc; do
    printf '  %-12s %-5s %s\n' "$name" "[$def]" "$desc"
  done
}

# 対話メニュー: 選択された name を1行ずつ出力
select_steps() {
  local binds="" idx=0 name def desc
  while IFS=$'\t' read -r name def desc; do
    idx=$((idx + 1))
    [[ "$def" == "on" ]] && binds="${binds:+$binds+}pos($idx)+select"
  done < <(list_steps)

  if has fzf; then
    list_steps | awk -F'\t' '{printf "%-12s %s\n", $1, $3}' |
      fzf --multi --reverse --height 70% --border \
        --header 'Tab: 選択/解除  Enter: 実行  Esc: 中止' \
        --prompt 'セットアップ項目> ' \
        --bind "start:${binds}+first" |
      awk '{print $1}'
    return
  fi

  # fzf 未導入 (初回) のフォールバック: 番号入力
  warn "fzf が見つからないため番号入力にフォールバックします (deps で fzf が入ります)" >&2
  local i=0
  while IFS=$'\t' read -r name def desc; do
    i=$((i + 1))
    printf '  %2d) %-12s %s\n' "$i" "$name" "$desc" >&2
  done < <(list_steps)
  printf '番号をスペース区切りで入力 (空=標準セット, a=全部): ' >&2
  local input
  read -r input
  if [[ -z "$input" ]]; then
    list_steps | awk -F'\t' '$2=="on"{print $1}'
  elif [[ "$input" == "a" ]]; then
    list_steps | cut -f1
  else
    local n
    for n in $input; do
      list_steps | sed -n "${n}p" | cut -f1
    done
  fi
}

run_step() {
  local name="$1" file
  if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
    err "不正な項目名: $name"
    return 1
  fi
  file="$(ls "$STEPS_DIR"/*-"$name".sh 2>/dev/null | head -1)"
  if [[ -z "$file" ]]; then
    err "不明な項目: $name （--list で確認）"
    return 1
  fi
  echo ""
  info "=== $name: $(step_meta "$file" desc) ==="
  # 項目ごとに別プロセスで実行し、set -e を有効にする
  bash -c 'set -euo pipefail; source "$1"; source "$2"; run' _ "$ROOT/scripts/lib.sh" "$file"
}

main() {
  local mode="menu" only=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --all) mode="all" ;;
    --only)
      mode="only"
      only="${2:-}"
      shift
      ;;
    --list)
      print_list
      exit 0
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      err "不明なオプション: $1"
      usage
      exit 1
      ;;
    esac
    shift
  done

  local selected=""
  case "$mode" in
  all) selected="$(list_steps | awk -F'\t' '$2=="on"{print $1}')" ;;
  only) selected="$(echo "$only" | tr ',' '\n')" ;;
  menu)
    if [[ ! -t 0 ]]; then
      err "対話端末ではありません。--all か --only を指定してください"
      exit 1
    fi
    selected="$(select_steps)"
    ;;
  esac

  if [[ -z "$selected" ]]; then
    echo "実行する項目がありません"
    exit 0
  fi

  local failed="" name
  for name in $selected; do
    run_step "$name" || failed="$failed $name"
  done

  echo ""
  if [[ -n "$failed" ]]; then
    err "失敗した項目:$failed"
    exit 1
  fi
  info "✓ セットアップ完了"
  echo "${YELLOW}次のステップ:${NC}"
  echo "  1. ターミナルを再起動してください"
  echo "  2. Neovim を起動してプラグインをインストール: nvim"
  echo "  3. 状態確認: make status"
}

main "$@"
