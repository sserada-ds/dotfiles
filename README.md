# dotfiles

個人用dotfiles設定。Zsh、Neovim、Tmux, Gitの設定を含みます。

**対応OS**: macOS / Linux

## 含まれる設定

### Zsh

- **プラグインマネージャー**: [zinit](https://github.com/zdharma-continuum/zinit)
- **テーマ**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- **プラグイン**:
  - zsh-completions - 補完機能の強化
  - zsh-autosuggestions - コマンド履歴からの自動提案
  - zsh-syntax-highlighting - コマンドのシンタックスハイライト
  - fzf - ファジーファインダー
- **詳細**: [.zsh/README.md](./.zsh/README.md)

### Neovim

- **プラグインマネージャー**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **主要プラグイン**:
  - neo-tree.nvim - ファイルエクスプローラー
  - telescope.nvim - ファジーファインダー
  - nvim-treesitter - シンタックスハイライト
  - nvim-lspconfig + mason.nvim - LSP統合
  - nvim-cmp - 自動補完
  - gitsigns.nvim - Git統合
  - GitHub Copilot - AI補完
  - lualine.nvim - ステータスライン
  - which-key.nvim - キーマップヘルプ
  - nvim-surround - 括弧操作
  - trouble.nvim - 診断リスト
- **詳細**: [.config/nvim/lua/plugins/README.md](./.config/nvim/lua/plugins/README.md)

### Git

- **設定テンプレート**: [.gitconfig.template](./.gitconfig.template)
- **エディタ**: Neovim
- **コミットテンプレート**: [.commit_template](./.commit_template)
- **主な設定**:
  - カラー表示有効化
  - 便利なエイリアス（st, co, lg等）
  - pull時のrebase設定
  - 見やすいdiff設定
  - Git LFS対応
- **注意**: `.gitconfig`はテンプレートから生成されます（追跡されません）

### uv

- **ツール**: [uv](https://docs.astral.sh/uv/)
- **機能**: 超高速な Python パッケージマネージャー・プロジェクト管理ツール
- **特徴**:
  - pip の 10〜100 倍高速
  - プロジェクト管理・仮想環境管理
  - Python バージョン管理
- **使い方**:
  - `uv init my-project` - 新規プロジェクト作成
  - `uv venv` - 仮想環境作成
  - `uv pip install <package>` - パッケージインストール
- **詳細**: README の uv セクションを参照

### モダンCLIツール

Rust製を中心としたモダンなCLIツールが含まれています：

**コア置き換え:**

- **bat** - `cat`の代替（シンタックスハイライト）
- **eza** - `ls`の代替（アイコン、カラー表示）
- **fd** - `find`の代替（高速、直感的）
- **ripgrep (rg)** - `grep`の代替（超高速検索）
- **zoxide** - `cd`の代替（頻繁に訪れるディレクトリへジャンプ）

**開発ツール:**

- **git-delta** - Git差分の美しい表示
- **jq** - JSON処理
- **gh** - GitHub公式CLI
- **lazygit** - Git TUI（エイリアス: `lg`）
- **hyperfine** - コマンドベンチマーク（エイリアス: `bench`）
- **tldr** - 簡易マニュアル
- **direnv** - ディレクトリ別環境変数管理
- **httpie** - HTTP client（エイリアス: `get`, `post`, `put`, `delete`）
- **glow** - Markdownビューア（エイリアス: `md`）
- **tokei** - コード統計
- **dust** - ディスク使用量の視覚化
- **bottom** - システムモニター（エイリアス: `top`, `htop`）
- **procs** - プロセス一覧（エイリアス: `pps`）
- **sd** - 直感的な置換ツール
- **just** - タスクランナー
- **watchexec** - ファイル監視
- **duf** - ディスク容量表示（エイリアス: `df`）

**ユーティリティ:**

- **atuin** - シェル履歴の検索・同期（Ctrl+Rの置き換え）
- **pv** - パイプラインの進捗表示
- **mkcert** - ローカル開発用SSL証明書生成
- **zellij** - モダンなターミナルマルチプレクサ（tmux代替）
- **navi** - インタラクティブなチートシート（Ctrl+Gで起動）
- **jless** - JSONインタラクティブビューア
- **doggo** - モダンなDNS lookup（digの代替）
- **bandwhich** - ネットワーク帯域幅モニター
- **silicon** - コードスクリーンショット生成

詳細な使い方は [docs/tools/](./docs/tools/) を参照してください：

- [Git & GitHub](./docs/tools/git.md)
- [Shell Tools](./docs/tools/shell.md)
- [Development Tools](./docs/tools/dev.md)
- [System Tools](./docs/tools/system.md)

### tmux

- **設定ファイル**: [.tmux.conf](./.tmux.conf)
- **詳細**: [tmux.md](./tmux.md)
- **Prefixキー**: `Ctrl + t`（デフォルトの`Ctrl + b`から変更）
- **主要プラグイン**:
  - tpm - tmuxプラグインマネージャー
  - tmux-sensible - 常識的なデフォルト設定
  - tmux-resurrect / tmux-continuum - セッションの保存と復元
  - tmux-yank - OSクリップボード連携
  - tmux-open - URLやファイルパスを開く
  - tmux-fzf - 統合fzf管理UI
  - tmux-thumbs - 高速テキスト選択
  - tmux-session-wizard - zoxide統合セッション管理
  - extrakto - ターミナル出力からテキスト抽出
  - tmux-gruvbox - Gruvboxテーマ
  - tmux-cpu - CPU使用率表示
  - tmux-battery - バッテリー残量表示
- **最適化設定**:
  - escape-time 0 - Vim/Neovimのモード切替遅延を解消
  - history-limit 50000 - スクロールバックを大幅に増加
  - Vi copy-mode - Viスタイルのキーバインド
  - 番号付けを1から開始（キーボード操作が容易）

### iTerm2

- **設定ディレクトリ**: [.config/iterm2/](./.config/iterm2/)
- **管理方式**: カスタムフォルダから設定を読み込み
- **含まれる設定**:
  - プロファイル設定（カラースキーム、フォントなど）
  - キーバインド
  - ホットキー設定
- **注意**: iTerm2の設定は `~/dotfiles/.config/iterm2/` から自動的に読み込まれます

### EditorConfig

- **設定ファイル**: [.editorconfig](./.editorconfig)
- **適用範囲**: 全てのエディタで統一されたコーディングスタイル
- **主な設定**:
  - UTF-8エンコーディング
  - LF改行コード
  - 2スペースインデント（Lua、JavaScript、Shell、YAML、JSONなど）
  - Makefileのみタブインデント

## インストール

### 必要要件

- macOS または Linux
- [Homebrew](https://brew.sh/) (macOS) または パッケージマネージャー (Linux)
- Git

### 1. リポジトリのクローン

```bash
git clone https://github.com/sserada/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. 全てをインストール

```bash
make install
```

これにより以下が自動的に実行されます：

1. 依存パッケージのインストール（Neovim, Git, モダンCLIツールなど）
2. 既存の設定ファイルをバックアップ（`backup/`ディレクトリ）
3. シンボリックリンクの作成
4. Git設定の適用（ユーザー名とメールアドレスの入力を求められます）
5. tmuxプラグインマネージャー(tpm)のインストール
6. Claude Code設定の適用
7. SuperClaude Frameworkのインストール
8. uv (Python パッケージマネージャー) のインストール
9. mkcert (ローカル開発用SSL証明書) の設定確認（オプション）

**個別インストール:**

必要に応じて個別のコンポーネントのみインストールすることもできます：

```bash
make install-deps      # 依存パッケージのみ
make install-links     # シンボリックリンクのみ
make install-git       # Git設定のみ
```

### 3. シェルの再起動

```bash
exec zsh
```

初回起動時：

- zinitがプラグインを自動インストール
- Powerlevel10k設定ウィザードが表示される

### 4. Neovimのセットアップ

```bash
nvim
```

初回起動時にlazy.nvimがプラグインを自動インストールします。

### 5. iTerm2の設定（macOSのみ）

iTerm2の設定は `~/dotfiles/.config/iterm2/` から自動的に読み込まれます。

**初回セットアップ後:**

1. iTerm2を**再起動**してください
2. 現在の設定が自動的に `~/dotfiles/.config/iterm2/` にエクスポートされます
3. 以降、設定変更は自動的にこのディレクトリに保存されます

**注意**: iTerm2の設定は既に `make install` で自動的に設定されています。

## Makefileコマンド

| コマンド                   | 説明                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------- |
| `make help`                | 使用可能なコマンドを表示                                                                                |
| `make status`              | 現在のシンボリックリンク状態を確認                                                                      |
| `make install`             | 全てをインストール（依存パッケージ→バックアップ→リンク→Git設定→tmux→Claude Code→SuperClaude→uv→mkcert） |
| `make install-deps`        | 必要なパッケージを Homebrew 経由でインストール                                                          |
| `make backup`              | 既存の設定をバックアップ                                                                                |
| `make install-links`       | シンボリックリンクのみを作成                                                                            |
| `make install-git`         | Git 設定のみを適用                                                                                      |
| `make install-tmux`        | tmux プラグインマネージャー(tpm)をインストール                                                          |
| `make install-claude`      | Claude Code 設定（hooks, notifications）を適用                                                          |
| `make install-superclaude` | SuperClaude Framework をインストール                                                                    |
| `make install-ollama`      | Ollama (ローカル LLM)をインストール                                                                     |
| `make install-uv`          | uv (Python パッケージマネージャー)をインストール                                                        |
| `make install-mkcert`      | mkcert (ローカル開発用SSL証明書) のCA設定（対話的）                                                     |
| `make uninstall`           | シンボリックリンクを削除                                                                                |
| `make restore`             | バックアップから復元                                                                                    |
| `make clean`               | バックアップディレクトリを削除                                                                          |
| `make format`              | コードをフォーマット                                                                                    |
| `make check-format`        | コードのフォーマットをチェック                                                                          |

## ディレクトリ構造

```
dotfiles/
├── .config/
│   ├── nvim/              # Neovim設定
│   │   ├── init.lua       # エントリーポイント
│   │   └── lua/
│   │       ├── config/    # 基本設定
│   │       └── plugins/   # プラグイン設定
│   │           ├── README.md
│   │           ├── completion/  # 補完系
│   │           ├── editing/     # 編集系
│   │           ├── finder/      # 検索系
│   │           ├── git/         # Git系
│   │           ├── lsp/         # LSP系
│   │           ├── ui/          # UI系
│   │           └── integration/ # 統合系
│   └── iterm2/            # iTerm2設定（macOS）
├── .zsh/                  # Zsh設定
│   ├── README.md          # Zsh設定の詳細
│   ├── zinit.zsh          # プラグイン管理
│   ├── fzf.zsh            # fzf設定
│   ├── option.zsh         # Zshオプション
│   ├── alias.zsh          # エイリアス定義
│   ├── p10k.zsh           # Powerlevel10kテーマ
│   ├── chrome.zsh         # Chrome関連
│   ├── path.zsh           # PATH設定
│   ├── direnv.zsh         # direnv初期化
│   └── tools.zsh          # モダンCLIツール初期化（zoxide, atuin）
├── docs/                  # ドキュメント
│   └── tools/             # CLIツールガイド
│       ├── README.md      # ツール一覧
│       ├── git.md         # Git & GitHub
│       ├── shell.md       # Shell Tools
│       ├── dev.md         # Development Tools
│       └── system.md      # System Tools
├── templates/             # テンプレート
│   └── claude/            # CLAUDE.mdテンプレート
├── .zshrc                 # Zshエントリーポイント
├── .gitconfig.template    # Git設定テンプレート
├── .gitconfig             # Git設定（生成されるファイル、追跡されない）
├── .commit_template       # Gitコミットテンプレート
├── .gitignore             # Git無視ファイル
├── .gitignore_global      # グローバル.gitignore
├── .editorconfig          # エディタ共通設定
├── Makefile               # インストール/管理スクリプト
├── .tmux.conf             # tmux設定ファイル
├── tmux.md                # tmux設定の詳細
└── README.md              # このファイル
```

## カスタマイズ

### Zsh

エイリアスやオプションを変更：

```bash
nvim ~/.zsh/alias.zsh
nvim ~/.zsh/option.zsh
source ~/.zshrc  # 再読み込み
```

macOS/Linuxなど、特定のOSだけで有効にしたいエイリアスは、`.zsh/alias.zsh`内のOS判定ブロックに記述します。

```bash
# .zsh/alias.zsh

# ... (共通のエイリアス)

# OS-specific aliases
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS-specific aliases
  # e.g. alias chrome='open -a "Google Chrome"'
fi
```

プラグインを追加：

```bash
nvim ~/.zsh/zinit.zsh
# zinit light <plugin-name> を追加
source ~/.zshrc
```

### Neovim

プラグインを追加：

1. `~/.config/nvim/lua/plugins/<category>/` に新しい`.lua`ファイルを作成
2. lazy.nvimが自動的に読み込みます

既存プラグインの設定変更：

```bash
nvim ~/.config/nvim/lua/plugins/<category>/<plugin>.lua
```

### Git

ユーザー名とメールアドレスを変更：

```bash
# 対話的に設定（推奨）
make install-git

# または手動で設定
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

テンプレートをカスタマイズ（dotfiles管理）：

```bash
nvim ~/dotfiles/.gitconfig.template
```

ローカルのGit設定を直接編集（追跡されない）：

```bash
nvim ~/.gitconfig
```

コミットテンプレートをカスタマイズ：

```bash
nvim ~/.commit_template
```

便利なGitエイリアス（設定済み）：

- `git st` - status
- `git co` - checkout
- `git lg` - 見やすいログ表示
- `git lga` - 全ブランチのグラフ表示

**注意**: `.gitconfig`はテンプレートから生成されます。個人的な設定（名前、メール等）は`.gitconfig`に保存され、Gitで追跡されません。

### tmux

`tmux.conf`を直接編集して設定をカスタマイズできます。

```bash
nvim ~/dotfiles/.tmux.conf
```

変更を反映するには、tmuxセッション内で`prefix` + `r` (`r`はリロードコマンド) を実行するか、tmuxセッションを再起動してください。

### uv

- **ツール**: [uv](https://docs.astral.sh/uv/)
- **機能**: 超高速な Python パッケージマネージャー・プロジェクト管理ツール
- **特徴**:
  - pip や pip-tools の 10〜100 倍高速
  - プロジェクト管理（`pyproject.toml` ベース）
  - 仮想環境管理
  - Python バージョン管理
  - Rust で実装され、依存関係なし

**基本的な使い方:**

```bash
# 新しいプロジェクトを作成
uv init my-project
cd my-project

# 仮想環境を作成
uv venv

# 仮想環境を有効化
source .venv/bin/activate  # macOS/Linux

# パッケージをインストール
uv pip install requests
uv pip install -r requirements.txt

# プロジェクトに依存関係を追加
uv add requests
uv add --dev pytest

# プロジェクトの依存関係をインストール
uv sync
```

**よく使うコマンド:**

```bash
# パッケージをインストール
uv pip install <package>

# パッケージをアンインストール
uv pip uninstall <package>

# 依存関係をロック
uv pip compile requirements.in -o requirements.txt

# プロジェクト管理
uv init           # 新規プロジェクト作成
uv add <package>  # 依存関係追加
uv sync           # 依存関係を同期
uv run <command>  # プロジェクト環境でコマンド実行
```

**インストール:**

```bash
# 個別にインストール
make install-uv

# または make install で自動的にインストール
make install
```

詳細: [uv Documentation](https://docs.astral.sh/uv/)

## トラブルシューティング

### Zsh

**プラグインがロードされない**

```bash
# zinitの再インストール
rm -rf ~/.local/share/zinit
exec zsh
```

**補完が効かない**

```bash
rm -f ~/.zcompdump*
autoload -Uz compinit && compinit
```

**fzfが見つからない**

```bash
brew install fzf
source ~/.zshrc
```

### Neovim

**プラグインがインストールされない**

```bash
nvim
# Neovim内で
:Lazy sync
```

**LSPが動かない**

```bash
nvim
# Neovim内で
:Mason
# 必要なLSPサーバーをインストール
```

**Treesitterのエラー**

```bash
nvim
# Neovim内で
:TSUpdate
```

### シンボリックリンク

**リンクが正しくない**

```bash
make status  # 状態確認
make uninstall  # 既存リンクを削除
make install-links  # 再作成
```

**元の設定に戻したい**

```bash
make restore  # バックアップから復元
```

## 主要なキーバインド

### Zsh

| キー                | 機能                                |
| ------------------- | ----------------------------------- |
| `Ctrl+R`            | fzfでコマンド履歴検索               |
| `Ctrl+F`            | fzfでファイル検索してエディタで開く |
| `Ctrl+G`            | fzfでディレクトリ検索して移動       |
| `Ctrl+P` / `Ctrl+N` | 履歴を前後検索                      |

### Neovim

| キー          | 機能                            |
| ------------- | ------------------------------- |
| `<leader>`    | スペースキー                    |
| `<leader>e`   | ファイルツリー表示/非表示       |
| `<leader>ff`  | ファイル検索                    |
| `<leader>fg`  | コード内を単語検索              |
| `<leader>fb`  | バッファ検索                    |
| `<leader>xx`  | 診断リスト表示                  |
| `gcc`         | 行のコメントアウト/アンコメント |
| `gc` (Visual) | 選択範囲のコメントアウト        |

### tmux

**基本操作:**

| キー         | 機能                   |
| ------------ | ---------------------- |
| `Ctrl + t`   | Prefixキー             |
| `prefix + d` | セッションからデタッチ |
| `tmux ls`    | セッション一覧表示     |
| `tmux a`     | セッションに再接続     |

**ペイン操作:**

| キー               | 機能               |
| ------------------ | ------------------ |
| `prefix + v`       | 左右に分割         |
| `prefix + s`       | 上下に分割         |
| `prefix + C-h`     | 左のペインに移動   |
| `prefix + C-j`     | 下のペインに移動   |
| `prefix + C-k`     | 上のペインに移動   |
| `prefix + C-l`     | 右のペインに移動   |
| `prefix + H/J/K/L` | ペインリサイズ     |
| `prefix + m`       | ペイン最大化トグル |

**ウィンドウ操作:**

| キー           | 機能               |
| -------------- | ------------------ |
| `prefix + c`   | 新規ウィンドウ作成 |
| `prefix + n`   | 次のウィンドウ     |
| `prefix + p`   | 前のウィンドウ     |
| `prefix + Tab` | 最後のウィンドウ   |
| `prefix + &`   | ウィンドウを閉じる |

**プラグイン機能:**

| キー             | 機能                                  |
| ---------------- | ------------------------------------- |
| `prefix + C-f`   | tmux-fzf統合UI                        |
| `prefix + Space` | tmux-thumbsテキスト選択               |
| `prefix + T`     | セッションウィザード（zoxide統合）    |
| `prefix + Tab`   | extraktoテキスト抽出                  |
| `prefix + F/W/P` | fzfでセッション/ウィンドウ/ペイン選択 |
| `prefix + r`     | 設定リロード                          |

**Copy mode（Vi風）:**

| キー     | 機能                 |
| -------- | -------------------- |
| `Escape` | Copy modeに入る      |
| `v`      | 選択開始             |
| `y`      | コピーしてモード終了 |

詳細は各README.mdを参照：

- [Zsh設定詳細](./.zsh/README.md)
- [Neovim設定詳細](./.config/nvim/lua/plugins/README.md)
- [tmux設定詳細](./tmux.md)

## 更新

```bash
cd ~/dotfiles
git pull
make install  # 必要に応じて
```

プラグインの更新：

```bash
# Zsh
exec zsh  # zinitが自動更新

# Neovim
nvim
:Lazy sync
```

## アンインストール

```bash
cd ~/dotfiles
make uninstall  # シンボリックリンクを削除
make restore    # バックアップから元の設定を復元
```

## ライセンス

このリポジトリは個人用の設定ファイルです。自由に使用・改変してください。
