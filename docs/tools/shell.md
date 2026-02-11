# Shell Tools

シェル体験を向上させるコア置き換えツール

---

## bat

`cat`の代替。シンタックスハイライト付きでファイルを表示。

**使い方:**

```bash
# ファイル表示（自動的にbatが使用される）
cat file.txt

# ページャーモード
bat --paging=always large-file.txt

# 行番号なし
bat -p file.txt

# 特定の言語で強制表示
bat -l python script.sh
```

**実用例:**

```bash
# ログファイルを見やすく
cat /var/log/system.log

# JSONを色付きで表示
cat config.json

# 複数ファイルを連結表示
cat *.md
```

---

## eza

`ls`の代替。アイコンとカラー表示。

**使い方:**

```bash
# 基本（自動的にezaが使用される）
ls

# 詳細表示
ll

# 隠しファイル含む
la

# ツリー表示
lt

# ツリーの深さ指定
eza --tree --level=2
```

**実用例:**

```bash
# Gitステータス付き
eza --git

# サイズでソート
eza -lS

# 更新日時でソート
eza -lt

# アイコンなし
eza --no-icons
```

---

## fd

`find`の代替。高速で直感的なファイル検索。

**使い方:**

```bash
# ファイル名で検索
fd pattern

# 拡張子で検索
fd -e js
fd -e md

# 大文字小文字を区別
fd -s Pattern

# 隠しファイルも含める
fd -H pattern
```

**実用例:**

```bash
# TypeScriptファイルを検索
fd -e ts -e tsx

# node_modulesを除外（デフォルト）
fd lib

# 完全一致
fd -g "exact-name.txt"

# 実行
fd -e sh -x chmod +x
```

---

## ripgrep (rg)

`grep`の代替。超高速なテキスト検索。

**使い方:**

```bash
# 基本検索
rg pattern

# ファイルタイプ指定
rg -t js pattern
rg -t python pattern

# 大文字小文字を無視
rg -i pattern

# 隠しファイルも検索
rg -. pattern
```

**実用例:**

```bash
# TODO を検索
rg "TODO|FIXME"

# 関数定義を検索
rg "function.*add"

# ファイル名のみ表示
rg -l pattern

# コンテキスト付き
rg -C 3 pattern
```

---

## zoxide

`cd`の代替。よく訪れるディレクトリへスマートにジャンプ。

**使い方:**

```bash
# キーワードでジャンプ
z projects
z dot

# 対話的に選択
zi project

# 使用頻度を表示
zoxide query -l
```

**実用例:**

```bash
# プロジェクトへ一発ジャンプ
z myapp

# 部分一致でジャンプ
z doc  # ~/dotfiles, ~/Documents など候補から選択

# 手動で追加
zoxide add /path/to/dir
```

---

## atuin

シェル履歴の強化。SQLiteベースの履歴管理。

**使い方:**

```bash
# 履歴検索（Ctrl+Rで起動）
# または
atuin search

# 統計表示
atuin stats

# 履歴をインポート
atuin import auto
```

**特徴:**

- **高度な検索**: フル Text検索、日時フィルタ
- **クロスマシン同期**: オプション（設定が必要）
- **統計**: よく使うコマンドを分析

**キーバインド:**

| キー      | 動作                   |
| --------- | ---------------------- |
| `Ctrl+R`  | 履歴検索               |
| `↑` / `↓` | 選択                   |
| `Enter`   | 実行                   |
| `Tab`     | コマンドラインにコピー |

---

## navi

インタラクティブなチートシート。

**使い方:**

```bash
# 起動
navi

# キーワードで検索
navi --query git

# ベストマッチを実行
navi --best-match
```

**チートシート作成:**

`~/.local/share/navi/cheats/my-cheats.cheat`を作成：

```
% git, branch

# ブランチを削除
git branch -d <branch>

$ branch: git branch | grep -v '*' | sed 's/^  //'
```

**実用例:**

```bash
# Docker コマンドを検索
navi --query docker

# Git rebase を検索
navi --query "git rebase"

# Kubernetes
navi --query kubectl
```

**キーバインド:**

| キー     | 動作                       |
| -------- | -------------------------- |
| `Ctrl+G` | naviを起動（Zshから）      |
| `Enter`  | コマンドを実行             |
| `Tab`    | コマンドをシェルに貼り付け |

---

## Tips

### コア置き換えツールのエイリアス

これらのツールは自動的に元のコマンドのエイリアスとして設定されています：

```bash
# .zsh/alias.zsh に設定済み
alias cat='bat --paging=never'
alias ls='eza --icons'
alias find='fd'
alias grep='rg'
alias cd='z'
```

### 元のコマンドを使いたい場合

```bash
# エイリアスをバイパス
\cat file.txt
\ls
\find . -name "*.txt"
```

### パフォーマンス

- **fd**: `find`より10-20倍高速
- **rg**: `grep`より10-100倍高速
- **bat**: `cat`とほぼ同速（小さいファイル）
- **eza**: `ls`と同等またはやや高速
- **zoxide**: ディレクトリ移動が劇的に高速化
