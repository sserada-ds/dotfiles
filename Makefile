SHELL := /bin/bash
.PHONY: help install uninstall backup restore clean status install-deps install-superclaude install-ollama install-uv install-claude install-mkcert format check-format

# デフォルトターゲット
.DEFAULT_GOAL := help

# カラー出力
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# パス設定
DOTFILES_DIR := $(shell pwd)
BACKUP_DIR := $(DOTFILES_DIR)/backup
HOME_DIR := $(HOME)

# リンク対象のファイル/ディレクトリ
DOTFILES := .zshrc .zsh .commit_template .tmux.conf .editorconfig .gitignore_global
CONFIG_DIRS := nvim iterm2 wezterm

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

help: ## ヘルプを表示
	@echo "$(BLUE)Dotfiles Management$(NC)"
	@echo ""
	@echo "$(GREEN)使用可能なコマンド:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)使用例:$(NC)"
	@echo "  make install      # 全てをインストール"
	@echo "  make status       # リンク状態を確認"
	@echo "  make uninstall    # 全てをアンインストール"

install: install-deps backup install-links install-git install-tmux install-claude install-superclaude install-uv install-mkcert ## 全てをインストール（依存パッケージ→バックアップ→リンク作成→Git設定→tmux→Claude Code→SuperClaude→uv→mkcert）
	@echo "$(GREEN)✓ インストール完了！$(NC)"
	@echo "$(YELLOW)次のステップ:$(NC)"
	@echo "  1. ターミナルを再起動してください"
	@echo "  2. Powerlevel10k設定ウィザードが表示されます"
	@echo "  3. Neovimを起動してプラグインをインストール: nvim"
	@echo "  4. Claude Codeを再起動してSuperClaudeコマンドを使用: claude"

install-deps: ## 必要な依存パッケージをインストール
	@echo "$(BLUE)必要なパッケージをインストール中...$(NC)"
	@if command -v brew &> /dev/null; then \
		echo "$(YELLOW)Homebrewを使用してインストール...$(NC)"; \
		brew install neovim git fzf bat eza zoxide ripgrep fd prettier shfmt stylua pipx node \
			git-delta jq gh lazygit hyperfine tlrc direnv httpie \
			glow tokei dust bottom procs sd just watchexec duf \
			atuin pv mkcert zellij navi doggo jless bandwhich silicon; \
	elif command -v apt &> /dev/null; then \
		echo "$(YELLOW)aptを使用してインストール (Ubuntu/Debian)...$(NC)"; \
		sudo apt update; \
		sudo apt install -y neovim git fzf bat ripgrep fd-find direnv httpie curl jq pipx \
			unzip build-essential libnss3-tools pv; \
		echo ""; \
		echo "$(BLUE)bat/fd のシンボリックリンクを作成中...$(NC)"; \
		mkdir -p $(HOME_DIR)/.local/bin; \
		if command -v batcat &> /dev/null && ! command -v bat &> /dev/null; then \
			ln -sf $$(which batcat) $(HOME_DIR)/.local/bin/bat; \
			echo "  $(GREEN)✓$(NC) bat -> batcat"; \
		fi; \
		if command -v fdfind &> /dev/null && ! command -v fd &> /dev/null; then \
			ln -sf $$(which fdfind) $(HOME_DIR)/.local/bin/fd; \
			echo "  $(GREEN)✓$(NC) fd -> fdfind"; \
		fi; \
		echo ""; \
		echo "$(BLUE)GitHub CLIをインストール中...$(NC)"; \
		if ! command -v gh &> /dev/null; then \
			curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg; \
			echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null; \
			sudo apt update; \
			sudo apt install -y gh; \
		else \
			echo "  $(GREEN)✓$(NC) gh は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)Node.js をインストール中...$(NC)"; \
		if ! command -v node &> /dev/null; then \
			curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -; \
			sudo apt install -y nodejs; \
		else \
			echo "  $(GREEN)✓$(NC) node は既にインストール済み ($$(node --version))"; \
		fi; \
		echo ""; \
		echo "$(BLUE)npm パッケージをインストール中...$(NC)"; \
		if command -v npm &> /dev/null; then \
			sudo npm install -g prettier || true; \
		else \
			echo "  $(YELLOW)⚠$(NC) npm が見つかりません。prettier のインストールをスキップ"; \
		fi; \
		echo ""; \
		echo "$(BLUE)git-delta をインストール中...$(NC)"; \
		if ! command -v delta &> /dev/null; then \
			DELTA_VERSION=$$(curl -sL https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'); \
			if [ -n "$$DELTA_VERSION" ]; then \
				curl -fsSL "https://github.com/dandavison/delta/releases/download/$${DELTA_VERSION}/git-delta_$${DELTA_VERSION}_$$(dpkg --print-architecture).deb" -o /tmp/git-delta.deb; \
				sudo dpkg -i /tmp/git-delta.deb; \
				rm -f /tmp/git-delta.deb; \
			else \
				echo "  $(YELLOW)⚠$(NC) git-delta のバージョン取得に失敗"; \
			fi; \
		else \
			echo "  $(GREEN)✓$(NC) delta は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)eza をインストール中...$(NC)"; \
		if ! command -v eza &> /dev/null; then \
			sudo mkdir -p /etc/apt/keyrings; \
			wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg; \
			echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null; \
			sudo chmod 644 /etc/apt/keyrings/gierens.gpg; \
			sudo apt update; \
			sudo apt install -y eza; \
		else \
			echo "  $(GREEN)✓$(NC) eza は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)zoxide をインストール中...$(NC)"; \
		if ! command -v zoxide &> /dev/null; then \
			curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh; \
		else \
			echo "  $(GREEN)✓$(NC) zoxide は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)atuin をインストール中...$(NC)"; \
		if ! command -v atuin &> /dev/null; then \
			curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh; \
		else \
			echo "  $(GREEN)✓$(NC) atuin は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)shfmt をインストール中...$(NC)"; \
		if ! command -v shfmt &> /dev/null; then \
			SHFMT_VERSION=$$(curl -sL https://api.github.com/repos/mvdan/sh/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'); \
			if [ -n "$$SHFMT_VERSION" ]; then \
				ARCH=$$(dpkg --print-architecture); \
				if [ "$$ARCH" = "amd64" ]; then GOARCH="amd64"; else GOARCH="arm64"; fi; \
				curl -fsSL "https://github.com/mvdan/sh/releases/download/$${SHFMT_VERSION}/shfmt_$${SHFMT_VERSION}_linux_$${GOARCH}" -o $(HOME_DIR)/.local/bin/shfmt; \
				chmod +x $(HOME_DIR)/.local/bin/shfmt; \
			else \
				echo "  $(YELLOW)⚠$(NC) shfmt のバージョン取得に失敗"; \
			fi; \
		else \
			echo "  $(GREEN)✓$(NC) shfmt は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)stylua をインストール中...$(NC)"; \
		if ! command -v stylua &> /dev/null; then \
			STYLUA_VERSION=$$(curl -sL https://api.github.com/repos/JohnnyMorganz/StyLua/releases/latest | grep '"tag_name"' | head -1 | sed 's/.*"tag_name": *"//;s/".*//'); \
			if [ -n "$$STYLUA_VERSION" ]; then \
				ARCH=$$(dpkg --print-architecture); \
				if [ "$$ARCH" = "amd64" ]; then SARCH="linux-x86_64"; else SARCH="linux-aarch64"; fi; \
				curl -fsSL "https://github.com/JohnnyMorganz/StyLua/releases/download/$${STYLUA_VERSION}/stylua-$${SARCH}.zip" -o /tmp/stylua.zip; \
				unzip -o /tmp/stylua.zip -d $(HOME_DIR)/.local/bin/; \
				chmod +x $(HOME_DIR)/.local/bin/stylua; \
				rm -f /tmp/stylua.zip; \
			else \
				echo "  $(YELLOW)⚠$(NC) stylua のバージョン取得に失敗"; \
			fi; \
		else \
			echo "  $(GREEN)✓$(NC) stylua は既にインストール済み"; \
		fi; \
		echo ""; \
		echo "$(BLUE)Rust ツール群をインストール中 (cargo)...$(NC)"; \
		if ! command -v cargo &> /dev/null; then \
			echo "  Rust をインストール中..."; \
			curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
			. "$(HOME_DIR)/.cargo/env"; \
		fi; \
		if command -v cargo &> /dev/null; then \
			echo "  cargo install: bottom procs sd du-dust tokei hyperfine just watchexec-cli tealdeer duf"; \
			cargo install bottom procs sd du-dust tokei hyperfine just watchexec-cli tealdeer duf; \
		else \
			echo "  $(RED)✗$(NC) cargo が見つかりません。Rust ツール群のインストールをスキップ"; \
		fi; \
		echo ""; \
		echo "$(YELLOW)注意:$(NC) 以下は手動インストールが推奨されます:"; \
		echo "  - lazygit: https://github.com/jesseduffield/lazygit#installation"; \
		echo "  - glow: https://github.com/charmbracelet/glow#installation"; \
		echo "  - navi: https://github.com/denisidoro/navi#installation"; \
		echo "  - jless: https://github.com/PaulJuliworker/jless#installation"; \
		echo "  - doggo: https://github.com/mr-karan/doggo#installation"; \
		echo "  - bandwhich: https://github.com/imsnif/bandwhich#installation"; \
		echo "  - silicon: https://github.com/Aloxaf/silicon#installation"; \
		echo "  - zellij: https://github.com/zellij-org/zellij#installation"; \
	elif command -v pacman &> /dev/null; then \
		echo "$(YELLOW)pacmanを使用してインストール (Arch Linux)...$(NC)"; \
		sudo pacman -S --noconfirm neovim git fzf bat eza zoxide ripgrep fd \
			git-delta jq github-cli lazygit hyperfine tldr direnv httpie \
			glow tokei dust bottom procs sd just watchexec duf \
			atuin pv mkcert zellij navi doggo bandwhich silicon; \
	elif command -v dnf &> /dev/null; then \
		echo "$(YELLOW)dnfを使用してインストール (Fedora/RHEL)...$(NC)"; \
		sudo dnf install -y neovim git fzf bat eza zoxide ripgrep fd-find \
			git-delta jq gh lazygit direnv httpie; \
		echo "$(YELLOW)注意:$(NC) 以下は手動インストールが推奨されます:"; \
		echo "  - Rust tools: cargo install hyperfine glow tokei du-dust bottom procs sd just watchexec"; \
		echo "  - tldr: cargo install tealdeer"; \
		echo "  - duf: GitHub Releasesからダウンロード"; \
	else \
		echo "$(RED)✗ サポートされているパッケージマネージャーが見つかりません$(NC)"; \
		echo "  手動でパッケージをインストールしてください:"; \
		echo "  - Core: neovim, git, fzf, bat, eza, zoxide, ripgrep, fd"; \
		echo "  - Level 1: git-delta, jq, gh, lazygit"; \
		echo "  - Level 2: hyperfine, tldr, direnv, httpie"; \
		echo "  - Level 3: glow, tokei, dust, bottom, procs, sd, just, watchexec, duf"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ パッケージのインストール完了$(NC)"

backup: ## 既存の設定をバックアップ
	@echo "$(BLUE)既存の設定をバックアップ中...$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@for file in $(DOTFILES); do \
		if [ -e "$(HOME_DIR)/$$file" ] && [ ! -L "$(HOME_DIR)/$$file" ]; then \
			echo "  $(YELLOW)バックアップ:$(NC) $$file"; \
			mv "$(HOME_DIR)/$$file" "$(BACKUP_DIR)/$$file"; \
		fi; \
	done
	@if [ -d "$(HOME_DIR)/.config" ]; then \
		mkdir -p $(BACKUP_DIR)/.config; \
		for dir in $(CONFIG_DIRS); do \
			if [ -e "$(HOME_DIR)/.config/$$dir" ] && [ ! -L "$(HOME_DIR)/.config/$$dir" ]; then \
				echo "  $(YELLOW)バックアップ:$(NC) .config/$$dir"; \
				mv "$(HOME_DIR)/.config/$$dir" "$(BACKUP_DIR)/.config/$$dir"; \
			fi; \
		done; \
	fi
	@echo "$(GREEN)✓ バックアップ完了:$(NC) $(BACKUP_DIR)"

install-links: ## シンボリックリンクを作成
	@echo "$(BLUE)シンボリックリンクを作成中...$(NC)"
	@for file in $(DOTFILES); do \
		if [ -e "$(HOME_DIR)/$$file" ] && [ ! -L "$(HOME_DIR)/$$file" ]; then \
			echo "$(RED)✗ $$file は既に存在します（シンボリックリンクではありません）$(NC)"; \
			echo "  'make backup' を先に実行してください"; \
			exit 1; \
		fi; \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			echo "  $(YELLOW)スキップ:$(NC) $$file （既にリンク済み）"; \
		else \
			ln -sv "$(DOTFILES_DIR)/$$file" "$(HOME_DIR)/$$file"; \
			echo "  $(GREEN)✓ リンク:$(NC) $$file"; \
		fi; \
	done
	@mkdir -p $(HOME_DIR)/.config
	@for dir in $(CONFIG_DIRS); do \
		if [ -e "$(HOME_DIR)/.config/$$dir" ] && [ ! -L "$(HOME_DIR)/.config/$$dir" ]; then \
			echo "$(RED)✗ .config/$$dir は既に存在します（シンボリックリンクではありません）$(NC)"; \
			echo "  'make backup' を先に実行してください"; \
			exit 1; \
		fi; \
		if [ -L "$(HOME_DIR)/.config/$$dir" ]; then \
			echo "  $(YELLOW)スキップ:$(NC) .config/$$dir （既にリンク済み）"; \
		else \
			ln -sv "$(DOTFILES_DIR)/.config/$$dir" "$(HOME_DIR)/.config/$$dir"; \
			echo "  $(GREEN)✓ リンク:$(NC) .config/$$dir"; \
		fi; \
	done
	@echo "$(GREEN)✓ リンク作成完了$(NC)"

install-git: ## Git設定を適用
	@echo "$(BLUE)Git設定を適用中...$(NC)"
	@# .gitconfigがなければテンプレートからコピー
	@if [ ! -f "$(HOME_DIR)/.gitconfig" ]; then \
		echo "$(YELLOW).gitconfigが存在しません。テンプレートからコピーします...$(NC)"; \
		cp "$(DOTFILES_DIR)/.gitconfig.template" "$(HOME_DIR)/.gitconfig"; \
		echo "  $(GREEN)✓ .gitconfigを作成:$(NC) ~/.gitconfig"; \
	else \
		echo "  $(GREEN)✓ .gitconfig:$(NC) 既に存在します"; \
	fi
	@echo ""
	@git config --global core.editor "nvim"
	@git config --global commit.template "$${HOME}/.commit_template"
	@git config --global core.excludesfile "$${HOME}/.gitignore_global"
	@echo "  $(GREEN)✓ エディタ:$(NC) nvim"
	@echo "  $(GREEN)✓ コミットテンプレート:$(NC) ~/.commit_template"
	@echo "  $(GREEN)✓ グローバル.gitignore:$(NC) ~/.gitignore_global"
	@echo ""
	@# ユーザー名の設定確認
	@current_name=$$(git config --global user.name 2>/dev/null || echo ""); \
	if [ -z "$$current_name" ]; then \
		echo "$(YELLOW)Git user.name が設定されていません$(NC)"; \
		printf "$(BLUE)ユーザー名を入力してください:$(NC) "; \
		read user_name; \
		if [ -n "$$user_name" ]; then \
			git config --global user.name "$$user_name"; \
			echo "  $(GREEN)✓ ユーザー名:$(NC) $$user_name"; \
		else \
			echo "  $(YELLOW)スキップ:$(NC) ユーザー名"; \
		fi; \
	else \
		echo "  $(GREEN)✓ ユーザー名:$(NC) $$current_name （既に設定済み）"; \
	fi
	@# メールアドレスの設定確認
	@current_email=$$(git config --global user.email 2>/dev/null || echo ""); \
	if [ -z "$$current_email" ]; then \
		echo "$(YELLOW)Git user.email が設定されていません$(NC)"; \
		printf "$(BLUE)メールアドレスを入力してください:$(NC) "; \
		read user_email; \
		if [ -n "$$user_email" ]; then \
			git config --global user.email "$$user_email"; \
			echo "  $(GREEN)✓ メールアドレス:$(NC) $$user_email"; \
		else \
			echo "  $(YELLOW)スキップ:$(NC) メールアドレス"; \
		fi; \
	else \
		echo "  $(GREEN)✓ メールアドレス:$(NC) $$current_email （既に設定済み）"; \
	fi
	@echo "$(GREEN)✓ Git設定完了$(NC)"

install-claude: ## Claude Code設定（hooks, settings, commands）を適用
	@echo "$(BLUE)Claude Code設定を適用中...$(NC)"
	@mkdir -p $(HOME_DIR)/.claude/hooks
	@mkdir -p $(HOME_DIR)/.claude/commands
	@# settings.jsonをコピー
	@if [ -f "$(DOTFILES_DIR)/.claude/settings.json" ]; then \
		cp "$(DOTFILES_DIR)/.claude/settings.json" "$(HOME_DIR)/.claude/settings.json"; \
		echo "  $(GREEN)✓ settings.json:$(NC) コピー完了"; \
	else \
		echo "  $(RED)✗ settings.json:$(NC) ソースファイルが見つかりません"; \
	fi
	@# hooks/をコピー
	@if [ -d "$(DOTFILES_DIR)/.claude/hooks" ]; then \
		cp -r "$(DOTFILES_DIR)/.claude/hooks/"* "$(HOME_DIR)/.claude/hooks/"; \
		chmod +x "$(HOME_DIR)/.claude/hooks/"*.sh; \
		echo "  $(GREEN)✓ hooks/:$(NC) コピー完了（実行権限付与）"; \
	else \
		echo "  $(RED)✗ hooks/:$(NC) ソースディレクトリが見つかりません"; \
	fi
	@# commands/をコピー
	@if [ -d "$(DOTFILES_DIR)/.claude/commands" ]; then \
		cp -r "$(DOTFILES_DIR)/.claude/commands/"* "$(HOME_DIR)/.claude/commands/"; \
		echo "  $(GREEN)✓ commands/:$(NC) コピー完了"; \
	else \
		echo "  $(YELLOW)⚠ commands/:$(NC) ソースディレクトリが見つかりません（スキップ）"; \
	fi
	@echo "$(GREEN)✓ Claude Code設定完了$(NC)"

install-tmux: ## tmuxプラグインマネージャー(tpm)をインストール
	@if [ ! -d "$(HOME_DIR)/.tmux/plugins/tpm" ]; then \
		echo "$(BLUE)tmuxプラグインマネージャー(tpm)をインストール中...$(NC)"; \
		git clone https://github.com/tmux-plugins/tpm "$(HOME_DIR)/.tmux/plugins/tpm"; \
	else \
		echo "$(YELLOW)スキップ:$(NC) tpmは既にインストール済みです"; \
	fi
	@echo "$(GREEN)✓ tpmのインストール完了$(NC)"

install-superclaude: ## SuperClaude Frameworkをインストール
	@echo "$(BLUE)SuperClaude Frameworkをインストール中...$(NC)"
	@if ! command -v pipx &> /dev/null; then \
		echo "$(RED)✗ pipxが見つかりません$(NC)"; \
		echo "  'make install-deps' を先に実行してください"; \
		exit 1; \
	fi
	@if ! pipx list | grep -q superclaude; then \
		echo "$(YELLOW)SuperClaudeをインストール中...$(NC)"; \
		pipx install superclaude; \
	else \
		echo "$(YELLOW)スキップ:$(NC) SuperClaudeは既にインストール済みです"; \
	fi
	@if [ -d "$(HOME_DIR)/.local/bin" ]; then \
		export PATH="$(HOME_DIR)/.local/bin:$$PATH"; \
		superclaude install; \
	else \
		echo "$(RED)✗ ~/.local/bin が見つかりません$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓ SuperClaudeのインストール完了$(NC)"

install-ollama: ## Ollama (ローカルLLM) をインストールして設定
	@echo "$(BLUE)Ollamaをインストール中...$(NC)"
	@if command -v ollama &> /dev/null; then \
		echo "$(YELLOW)スキップ:$(NC) Ollamaは既にインストール済みです"; \
	elif [ "$$(uname)" = "Darwin" ]; then \
		brew install ollama; \
	else \
		curl -fsSL https://ollama.com/install.sh | sh; \
	fi
	@echo "$(BLUE)Ollamaサービスを起動中...$(NC)"
	@if [ "$$(uname)" = "Darwin" ]; then \
		if ! brew services list | grep -q "ollama.*started"; then \
			brew services start ollama; \
			sleep 3; \
		fi; \
	else \
		if command -v systemctl &> /dev/null; then \
			sudo systemctl enable ollama 2>/dev/null || true; \
			sudo systemctl start ollama 2>/dev/null || true; \
			sleep 3; \
		fi; \
	fi
	@echo "$(BLUE)推奨モデル (qwen2.5-coder:7b) をダウンロード中...$(NC)"
	@echo "$(YELLOW)注意: 約4.7GBのダウンロードが必要です$(NC)"
	@ollama pull qwen2.5-coder:7b
	@echo "$(GREEN)✓ Ollamaのインストール完了$(NC)"
	@echo "$(YELLOW)使い方:$(NC)"
	@echo "  ollama run qwen2.5-coder:7b"

install-uv: ## uv (Python パッケージマネージャー) をインストール
	@echo "$(BLUE)uvをインストール中...$(NC)"
	@if command -v uv &> /dev/null; then \
		echo "$(YELLOW)スキップ:$(NC) uvは既にインストール済みです"; \
		uv --version; \
	else \
		echo "$(YELLOW)公式スクリプトからインストール中...$(NC)"; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		echo "$(GREEN)✓ uvのインストール完了$(NC)"; \
		echo ""; \
		echo "$(YELLOW)注意:$(NC) ターミナルを再起動するか、以下を実行してPATHを更新してください:"; \
		echo "  source ~/.zshrc"; \
	fi
	@echo "$(YELLOW)使い方:$(NC)"
	@echo "  uv init my-project    # 新しいプロジェクトを作成"
	@echo "  uv venv               # 仮想環境を作成"
	@echo "  uv pip install <pkg>  # パッケージをインストール"
	@echo "$(YELLOW)詳細:$(NC) https://docs.astral.sh/uv/"

install-mkcert: ## mkcert (ローカル開発用SSL証明書) のルートCA設定
	@echo "$(BLUE)mkcertのルートCA設定$(NC)"
	@if ! command -v mkcert &> /dev/null; then \
		echo "$(RED)✗ mkcertがインストールされていません$(NC)"; \
		echo "  'make install-deps' を実行してください"; \
		exit 1; \
	fi
	@echo ""
	@echo "$(YELLOW)mkcertのローカルCA（証明機関）を設定しますか？$(NC)"
	@echo "  localhostでHTTPS開発環境を使用する場合に必要です。"
	@echo "  管理者パスワードの入力が求められます。"
	@echo ""
	@printf "$(BLUE)設定しますか？ [y/N]:$(NC) "; \
	read answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo "$(BLUE)mkcert -install を実行中...$(NC)"; \
		mkcert -install; \
		echo "$(GREEN)✓ mkcertのCA設定完了$(NC)"; \
		echo "$(YELLOW)使い方:$(NC)"; \
		echo "  mkcert localhost 127.0.0.1 ::1"; \
		echo "  mkcert example.test"; \
	else \
		echo "$(YELLOW)スキップ:$(NC) mkcertのCA設定をスキップしました"; \
		echo "$(YELLOW)後で設定する場合:$(NC) mkcert -install"; \
	fi

uninstall: ## シンボリックリンクを削除
	@echo "$(BLUE)シンボリックリンクを削除中...$(NC)"
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			rm -v "$(HOME_DIR)/$$file"; \
			echo "  $(GREEN)✓ 削除:$(NC) $$file"; \
		fi; \
	done
	@for dir in $(CONFIG_DIRS); do \
		if [ -L "$(HOME_DIR)/.config/$$dir" ]; then \
			rm -v "$(HOME_DIR)/.config/$$dir"; \
			echo "  $(GREEN)✓ 削除:$(NC) .config/$$dir"; \
		fi; \
	done
	@echo "$(GREEN)✓ アンインストール完了$(NC)"

restore: ## バックアップから復元
	@if [ ! -d "$(BACKUP_DIR)" ]; then \
		echo "$(RED)✗ バックアップが見つかりません:$(NC) $(BACKUP_DIR)"; \
		exit 1; \
	fi
	@echo "$(BLUE)バックアップから復元中...$(NC)"
	@for file in $(DOTFILES); do \
		if [ -e "$(BACKUP_DIR)/$$file" ]; then \
			if [ -L "$(HOME_DIR)/$$file" ]; then \
				rm "$(HOME_DIR)/$$file"; \
			fi; \
			mv "$(BACKUP_DIR)/$$file" "$(HOME_DIR)/$$file"; \
			echo "  $(GREEN)✓ 復元:$(NC) $$file"; \
		fi; \
	done
	@if [ -d "$(BACKUP_DIR)/.config" ]; then \
		for dir in $(CONFIG_DIRS); do \
			if [ -e "$(BACKUP_DIR)/.config/$$dir" ]; then \
				if [ -L "$(HOME_DIR)/.config/$$dir" ]; then \
					rm "$(HOME_DIR)/.config/$$dir"; \
				fi; \
				mv "$(BACKUP_DIR)/.config/$$dir" "$(HOME_DIR)/.config/$$dir"; \
				echo "  $(GREEN)✓ 復元:$(NC) .config/$$dir"; \
			fi; \
		done; \
	fi
	@echo "$(GREEN)✓ 復元完了$(NC)"

clean: ## バックアップディレクトリを削除
	@if [ -d "$(BACKUP_DIR)" ]; then \
		echo "$(YELLOW)バックアップディレクトリを削除中...$(NC)"; \
		rm -rf "$(BACKUP_DIR)"; \
		echo "$(GREEN)✓ 削除完了:$(NC) $(BACKUP_DIR)"; \
	else \
		echo "$(YELLOW)バックアップディレクトリは存在しません$(NC)"; \
	fi

status: ## 現在のリンク状態を確認
	@echo "$(BLUE)=== リンク状態 ===$(NC)"
	@echo ""
	@for file in $(DOTFILES); do \
		if [ -L "$(HOME_DIR)/$$file" ]; then \
			target=$$(readlink "$(HOME_DIR)/$$file"); \
			if [ "$$target" = "$(DOTFILES_DIR)/$$file" ]; then \
				echo "$(GREEN)✓$(NC) $$file -> $$target"; \
			else \
				echo "$(YELLOW)!$(NC) $$file -> $$target $(YELLOW)(別のターゲット)$(NC)"; \
			fi; \
		elif [ -e "$(HOME_DIR)/$$file" ]; then \
			echo "$(RED)✗$(NC) $$file $(RED)(リンクではありません)$(NC)"; \
		else \
			echo "$(RED)✗$(NC) $$file $(RED)(存在しません)$(NC)"; \
		fi; \
	done
	@for dir in $(CONFIG_DIRS); do \
		if [ -L "$(HOME_DIR)/.config/$$dir" ]; then \
			target=$$(readlink "$(HOME_DIR)/.config/$$dir"); \
			if [ "$$target" = "$(DOTFILES_DIR)/.config/$$dir" ]; then \
				echo "$(GREEN)✓$(NC) .config/$$dir -> $$target"; \
			else \
				echo "$(YELLOW)!$(NC) .config/$$dir -> $$target $(YELLOW)(別のターゲット)$(NC)"; \
			fi; \
		elif [ -e "$(HOME_DIR)/.config/$$dir" ]; then \
			echo "$(RED)✗$(NC) .config/$$dir $(RED)(リンクではありません)$(NC)"; \
		else \
			echo "$(RED)✗$(NC) .config/$$dir $(RED)(存在しません)$(NC)"; \
		fi; \
	done
	@echo ""
	@echo "$(BLUE)=== Git設定 ===$(NC)"
	@echo "$(GREEN)エディタ:$(NC)           $$(git config --global core.editor || echo '未設定')"
	@echo "$(GREEN)コミットテンプレート:$(NC) $$(git config --global commit.template || echo '未設定')"
	@echo "$(GREEN)グローバル.gitignore:$(NC) $$(git config --global core.excludesfile || echo '未設定')"
	@echo ""
	@if [ -d "$(BACKUP_DIR)" ]; then \
		echo "$(BLUE)=== バックアップ ===$(NC)"; \
		echo "$(GREEN)✓ バックアップあり:$(NC) $(BACKUP_DIR)"; \
	fi
