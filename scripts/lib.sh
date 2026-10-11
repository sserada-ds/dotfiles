#!/usr/bin/env bash
# 共通ライブラリ (各スクリプトから source して使う)
# bash 3.2 (macOS 標準) でも動くように書くこと

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup"

# リンク対象: $HOME 直下 / ~/.config 配下 / VSCode User ディレクトリ
DOTFILES=(.zshrc .zsh .commit_template .tmux.conf .editorconfig .gitignore_global)
CONFIG_DIRS=(nvim iterm2 wezterm)
VSCODE_ITEMS=(settings.json keybindings.json snippets)

OS="$(uname)"
if [[ "$OS" == "Darwin" ]]; then
  VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
else
  VSCODE_USER_DIR="$HOME/.config/Code/User"
fi
VSCODE_SRC_DIR="$DOTFILES_DIR/.config/Code/User"

# ---------- 出力 ----------
if [[ -t 1 ]]; then
  RED=$'\033[0;31m' GREEN=$'\033[0;32m' YELLOW=$'\033[0;33m' BLUE=$'\033[0;34m' NC=$'\033[0m'
else
  RED='' GREEN='' YELLOW='' BLUE='' NC=''
fi

info() { printf '%s%s%s\n' "$BLUE" "$*" "$NC"; }
ok() { printf '  %s✓%s %s\n' "$GREEN" "$NC" "$*"; }
skip() { printf '  %sスキップ:%s %s\n' "$YELLOW" "$NC" "$*"; }
warn() { printf '  %s⚠%s %s\n' "$YELLOW" "$NC" "$*"; }
err() { printf '  %s✗%s %s\n' "$RED" "$NC" "$*" >&2; }

has() { command -v "$1" >/dev/null 2>&1; }

# ---------- 対話 ----------
# 非対話 (tty なし) のときは常に「いいえ」
confirm() {
  [[ -t 0 ]] || return 1
  local answer
  printf '%s%s [y/N]:%s ' "$BLUE" "$1" "$NC"
  read -r answer
  [[ "$answer" == "y" || "$answer" == "Y" ]]
}

# ---------- リンク ----------
# link_pairs <core|vscode|hooks|all>: "src<TAB>dest" を1行ずつ出力
link_pairs() {
  local group="${1:-all}" f d i
  if [[ "$group" == "core" || "$group" == "all" ]]; then
    for f in "${DOTFILES[@]}"; do
      printf '%s\t%s\n' "$DOTFILES_DIR/$f" "$HOME/$f"
    done
    for d in "${CONFIG_DIRS[@]}"; do
      printf '%s\t%s\n' "$DOTFILES_DIR/.config/$d" "$HOME/.config/$d"
    done
  fi
  if [[ "$group" == "hooks" || "$group" == "all" ]]; then
    printf '%s\t%s\n' "$DOTFILES_DIR/.config/git/hooks" "$HOME/.config/git/hooks"
  fi
  if [[ "$group" == "vscode" || "$group" == "all" ]]; then
    for i in "${VSCODE_ITEMS[@]}"; do
      printf '%s\t%s\n' "$VSCODE_SRC_DIR/$i" "$VSCODE_USER_DIR/$i"
    done
  fi
}

# $HOME 配下のパスに対応するバックアップ先
backup_path_for() {
  printf '%s/%s' "$BACKUP_DIR" "${1#"$HOME"/}"
}

# 既存ファイルを backup/ に退避
backup_existing() {
  local dest="$1" bak
  bak="$(backup_path_for "$dest")"
  [[ -e "$bak" || -L "$bak" ]] && bak="$bak.$(date +%Y%m%d%H%M%S)"
  mkdir -p "$(dirname "$bak")"
  mv "$dest" "$bak"
  warn "既存を退避: ${dest#"$HOME"/} -> ${bak#"$DOTFILES_DIR"/}"
}

# link_item <src> <dest>: 既存が実体なら退避してからリンクを張る (冪等)
link_item() {
  local src="$1" dest="$2" label="${2#"$HOME"/}"
  if [[ ! -e "$src" ]]; then
    skip "$label （ソースが存在しません）"
    return 0
  fi
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    skip "$label （既にリンク済み）"
    return 0
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    backup_existing "$dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  ok "リンク: $label"
}

# ---------- パッケージ ----------
# 最新リリースのタグを取得 (GitHub API)
github_latest_tag() {
  curl -sL "https://api.github.com/repos/$1/releases/latest" |
    grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'
}
