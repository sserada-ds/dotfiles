SHELL := /bin/bash
.PHONY: help install status uninstall format check-format

.DEFAULT_GOAL := help

BLUE := $(shell printf '\033[0;34m')
GREEN := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
NC := $(shell printf '\033[0m')

# make install ALL=1 / make install ONLY=links,git を ./install.sh のオプションに変換
INSTALL_ARGS := $(if $(ALL),--all) $(if $(ONLY),--only $(ONLY))

help: ## ヘルプを表示
	@echo "$(BLUE)Dotfiles Management$(NC)"
	@echo ""
	@echo "$(GREEN)コマンド:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-14s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)セットアップ項目の選び方:$(NC)"
	@echo "  make install                 # 対話メニュー (fzf) で選んで実行"
	@echo "  make install ALL=1           # 標準セットを非対話で実行"
	@echo "  make install ONLY=links,git  # 指定した項目だけ実行"
	@echo "  ./install.sh --list          # 選べる項目の一覧"
	@echo ""
	@echo "$(GREEN)その他:$(NC)"
	@echo "  scripts/vscode-sync-ext.sh   # 導入済み VSCode 拡張を extensions.txt に書き出し"

install: ## セットアップ (対話メニュー / ALL=1 / ONLY=a,b)
	@./install.sh $(INSTALL_ARGS)

status: ## リンク状態と Git 設定を確認
	@./scripts/status.sh

uninstall: ## リンクを削除し、backup/ があれば復元
	@./scripts/uninstall.sh

format: ## 全てのファイルをフォーマット
	@echo "$(BLUE)フォーマット中...$(NC)"
	@prettier --write . --log-level warn
	@find . -path './backup' -prune -o \( -type f \( -name "*.sh" -o -name "*.zsh" \) \) -print | grep -v "p10k.zsh" | grep -v "zinit.zsh" | xargs shfmt -w
	@stylua .
	@echo "$(GREEN)✓ フォーマット完了！$(NC)"

check-format: ## ファイルのフォーマットをチェック
	@echo "$(BLUE)フォーマットをチェック中...$(NC)"
	@prettier --check .
	@find . -path './backup' -prune -o \( -type f \( -name "*.sh" -o -name "*.zsh" \) \) -print | grep -v "p10k.zsh" | grep -v "zinit.zsh" | xargs shfmt -d
	@stylua --check .
	@echo "$(GREEN)✓ フォーマットは正常です！$(NC)"
